require 'csv'

class Reservation < ApplicationRecord
  include Geocodable

  belongs_to :route, optional: true
  has_one :zone, through: :route
  has_many :donations, dependent: :nullify
  has_many :logs, dependent: :destroy

  enum :donation, { online_donation: 1, cash_or_check_donation: 2, no_donation: 3 }
  enum :status, { unconfirmed: 0, pending_pickup: 1, picked_up: 2, missing: 3, cancelled: 4, archived: 99, remind_me: 999 }, default: :unconfirmed
  enum :collected, { door_hanger: 1, cash: 2, check: 3 }

  enum :heard_about_source, { word_of_mouth: 4, 'Prior recycler, knew about it': 10, roadside_sign: 3, christmas_tree_lot_flyer: 7, email_reminder_from_us: 5, facebook: 1, 'Safeway/Ace Hardware flyer': 6,    'Town & Country reader board': 9, nextdoor: 2, newspaper: 8, other: 99 }


  scope :pending, -> { where.not(status: ['archived', 'cancelled', 'unconfirmed', 'remind_me'])}
  scope :active, -> { where.not(status: ['archived', 'remind_me'])}
  scope :not_active, -> { where(status: ['archived', 'remind_me'])}
  scope :unrouted, -> { where(route_id: nil) }
  scope :routed, -> { where.not(route_id: nil) }
  scope :not_polygon_routed, -> { where.not(route_id: nil).where.not(is_route_polygon: true)}

  validates :name, :email, presence: true

  attribute :is_routed, :boolean, default: true

  before_save :normalize_phone!
  before_save :downcase_email!

  after_commit :route_reservation, if: ->(obj){ obj.geocoded? && obj.is_routed? && (obj.saved_change_to_latitude? && (obj.persisted? || obj.route_id.nil?)) }

  # email delivery
  after_save :send_confirmed_reservation_email!, if: -> (obj){ obj.pending_pickup? && obj.saved_change_to_status? }
  after_update :send_cancelled_reservation_email!, if: -> (obj){ obj.cancelled? && obj.saved_change_to_status? }


  # sms delivery
  after_commit :send_missing_sms!, if: ->(obj){ obj.missing? && obj.phone.present? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :send_missing_email!, if: ->(obj){ obj.missing? && !obj.phone.present? && obj.saved_change_to_status? && obj.persisted? }

  # logging
  after_commit :log_unconfirmed!, if: ->(obj){ obj.unconfirmed? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_pending_pickup!, if: ->(obj){ obj.pending_pickup? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_picked_up!, if: ->(obj){ obj.picked_up? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_cancelled!, if: ->(obj){ obj.cancelled? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_missing!, if: ->(obj){ obj.missing? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_archived!, if: ->(obj){ obj.archived? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_remind_me!, if: ->(obj){ obj.remind_me? && obj.saved_change_to_status? && obj.persisted? }

  # turbo stream
  # after_update ReservationCallbacks
  after_update -> { broadcast_prepend_to "missing_reservations", partial: 'admin/reservations/reservation', target: 'reservations-table-body' }, if: -> (obj) { obj.saved_change_to_status? && obj.status == 'missing'}
  after_update -> { broadcast_prepend_to "reservation-status-changes", partial: 'admin/reservations/reservation', target: 'reservations-table-body' }, if: -> (obj) { obj.saved_change_to_status? }
  after_update -> { broadcast_prepend_to "picked_up_reservations", partial: 'admin/reservations/reservation', target: 'reservations-table-body' }, if: -> (obj) { obj.saved_change_to_status? && obj.status == 'picked_up'}

  def self.open?
    Setting.first_or_create.is_reservations_open?
  end

  def self.process_all_routes!
    not_archived.each do |r|
      r.route_reservation
      r.save
    end
  end

  def donation_status
    if donated_online?
      'online_donation'
    elsif donation == :cash_or_check_donation
      'cash_or_check_donation'
    elsif donation == :no_donation
      'no_donation'
    else
      nil
    end
  end

  def total_donations_amount
    donations.sum(:amount)
  end

  def donated_online?
    donations.sum(:amount) > 0
  end

  def routed?
    route.present?
  end

  def route!
    Router.new(self).route!
  end

  def route_reservation
    if Rails.env.test?
      self.route!
      self.save
    else
      RouteReservationJob.perform_later(self.id)
    end
  end

  def send_confirmed_reservation_email!
    ReservationsMailer.with(reservation: self).confirmed_reservation_email.deliver_later
  end

  def send_cancelled_reservation_email!
    ReservationsMailer.with(reservation: self).cancelled_reservation_email.deliver_later
  end

  def send_missing_sms!
    message = "Hello, it's Bainbridge Tree Recycle! We can't find your tree for pickup. "
    message += "Perhaps your tree has not been put out, or perhaps you no longer need it picked up. We want to make sure we pick it up for you. Please let us know by replying to this text message ASAP"
    message += ", or call us at #{ Setting&.first&.contact_phone }," if Setting&.first&.contact_phone.present?
    message += " if you would like us to  attempt a second pick-up of your tree today. "
    Sms.new.send_with_object(self, message)
  end

  def send_missing_email!
    return if self.phone.present?
    ReservationsMailer.with(reservation: self).missing_tree_email.deliver_later
  end

  # method to import data from existing tree recycle system csv export
  def self.import(file)
    Setting.first.update(is_emailing_enabled: false)
    CSV.foreach(file.path, headers: true) do |row|
      street = row['pickup_address'] == 'Pick-up Canceled' ? row['house'] + ' ' + row['street'] : row['pickup_address']
      name = row['full_name'].present? ? row['full_name'] : 'No name provided'
      reservation = Reservation.new(name: name, email: row['email'], street: street, phone: row['phone'], notes: row['comment'], latitude: row['lat'], longitude: row['lng'], house_number: row['house'], street_name: row['street'], route_name: row['route'], unit: row['unit'], status: 'archived', is_routed: false, no_emails: true, no_sms: true )
      unless reservation.save
        puts "*"*40
        puts row['email']
        puts reservation.errors.full_messages
      end
    end
  end

  def self.destroy_all_archived!
    Reservation.archived.destroy_all
  end

  # merges active with not-active (archived + remind mes) reservations
  def self.merge_unarchived_with_archived!
    Reservation.active.not_unconfirmed.each do |r|
      Reservation.not_active.where(email: r.email).destroy_all
      r.archived!
    end
  end

  def self.destroy_reservations_older_than_months(months)
    query = Reservation.where("created_at > ?", Time.now + months.to_i.months)
    count = query.count
    query.destroy_all
    count
  end

  # archived reservations that 1) have not been sent marketing, 2) are not pending (pending_pickup, picked_up, missing)
  def self.reservations_to_send_marketing_emails(attribute)

    # conditional required since result will be empty if there are no pending
    reservations_to_send = if Reservation.pending.empty?
        Reservation.not_active.
        where(attribute.to_sym => false).
        where(no_emails: false).
        order(:email)
    else
        Reservation.not_active.
        where("LOWER(email) NOT IN (?)", Reservation.pending.map { |r| r.email.downcase } ).
        where(attribute.to_sym => false).
        where(no_emails: false).
        order(:email)
    end
  end

  def routed_manually?
    !is_routed
  end

  def self.process_post_event!
    # destroy unconfirmed
    Reservation.unconfirmed.destroy_all
    Rails.logger.info "Destroyed unconfirmed reservations."

    # destroy unsubscribed
    Reservation.archived.where(no_emails: true).destroy_all
    Reservation.remind_me.where(no_emails: true).destroy_all
    Rails.logger.info "Destroyed archived and remind me emails that unsubscribed."

    # merge records, deleting older duplicate archived records
    Reservation.merge_unarchived_with_archived!
    Rails.logger.info "Archived all data."

    # disable geocoding / routing
    Reservation.update_all(is_geocoded: false, is_routed: false)
  end


  private

  def normalize_phone!
    self.phone = Phonelib.parse(phone).full_e164.presence if phone.present?
  end

  def log_unconfirmed!
    logs.create(message: "Reservation unconfirmed.")
  end

  def log_pending_pickup!
    logs.create(message: 'Tree is pending pickup.')
  end

  def log_picked_up!
    logs.create(message: 'Tree picked up.')
  end

  def log_missing!
    logs.create(message: 'Pickup attempted. Tree not found.')
  end

  def log_cancelled!
    logs.create(message: 'Reservation cancelled,')
  end

  def log_archived!
    logs.create(message: 'Reservation archived.')
  end

  def log_remind_me!
    logs.create(message: 'Remind me created.')
  end

end
