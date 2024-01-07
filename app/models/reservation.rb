require 'csv'

class Reservation < ApplicationRecord
  include Geocodable

  belongs_to :route, optional: true
  has_one :zone, through: :route
  has_many :donations, dependent: :nullify
  has_many :logs, dependent: :destroy
  has_many :events, dependent: :destroy

  enum :donation, { online_donation: 1, cash_or_check_donation: 2, no_donation: 3 }
  enum :status, { unconfirmed: 0, pending_pickup: 1, picked_up: 2, missing: 3, cancelled: 4, archived: 99, remind_me: 999 }, default: :unconfirmed
  enum :collected, { door_hanger: 1, cash: 2, check: 3 }

  enum :heard_about_source, { word_of_mouth: 4, 'Prior recycler, knew about it': 10, roadside_sign: 3, christmas_tree_lot_flyer: 7, email_reminder_from_us: 5, facebook: 1, 'Safeway/Ace Hardware flyer': 6,    'Town & Country reader board': 9, nextdoor: 2, newspaper: 8, other: 99 }


  scope :pending, -> { where.not(status: ['archived', 'cancelled', 'unconfirmed', 'remind_me'])}
  scope :active, -> { where.not(status: ['archived', 'remind_me', 'unconfirmed'])}
  scope :not_active, -> { where(status: ['archived', 'remind_me', 'unconfirmed'])}
  scope :unrouted, -> { where(route_id: nil) }
  scope :routed, -> { where.not(route_id: nil) }
  scope :not_polygon_routed, -> { where.not(route_id: nil).where.not(is_route_polygon: true)}
  scope :current_event, -> { where("created_at > ?", Date.today - 6.months)}
  scope :duplicate, -> { joins("LEFT OUTER JOIN reservations r on reservations.latitude = r.latitude AND reservations.longitude = r.longitude AND reservations.id <> r.id").where("reservations.status = 1 and r.status = 1").distinct("reservations.id").order("reservations.latitude, reservations.longitude") }
  scope :unsubscribed, -> { where(no_emails: true) }
  scope :duplicate_email, -> { joins("join reservations r on reservations.email = r.email AND reservations.id <> r.id").uniq{ |obj| obj.email } }

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
  after_commit :log_archived!, if: ->(obj){ obj.archived? && obj.saved_change_to_status? && obj.persisted? }, on: :update
  after_commit :log_remind_me!, if: ->(obj){ obj.remind_me? && obj.saved_change_to_status? && obj.persisted? }

  # merging in old record
  after_save :merge_in_archived!, if: ->(obj){ obj.pending_pickup? && obj.saved_change_to_status? && obj.persisted? }

  # turbo stream
  # after_update ReservationCallbacks
  after_update -> { broadcast_prepend_to "missing_reservations", partial: 'admin/reservations/reservation', target: 'reservations-table-body' }, if: -> (obj) { obj.saved_change_to_status? && obj.status == 'missing'}

  after_update -> { broadcast_prepend_to "missing", partial: 'admin/admin/reservation', target: 'reservations-missing' }, if: -> (obj) { obj.saved_change_to_status? && obj.status == 'missing' }
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
    message = "Hi there! It's Bainbridge Tree Recycle. We're having trouble finding your tree for pickup. Maybe it's not out, or you might not need it picked up anymore. Let us know by replying to this text ASAP if you would like us to  attempt a second pick-up of your tree today. Thanks!"
    message += " To stop receiving messages, reply STOP. "

    # Hi there! It's Bainbridge Tree Recycle. We're having trouble finding your tree for pickup. Our drivers are currently out collecting trees, and we want to make sure yours is on the list. Let us know by replying to this text ASAP. Thanks! Reply 'STOP' to opt out.
    Sms.new.send_with_object(self, message)
    self.logs.create(category: 'missing_tree_sms', message: 'Missing tree SMS sent')
  end

  def send_missing_email!(override=false)
    return if self.phone.present? && !override
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

  # merges active with not-active (archived + remind mes) reservations, leaving reservations with unique emails
  def self.merge_unarchived_with_archived!
    Reservation.clear_archive_email_duplicates!

    Reservation.active.not_unconfirmed.each do |r|
      Reservation.not_active.where(email: r.email).destroy_all
      r.archived!
    end
  end

  def self.clear_archive_email_duplicates!
    duplicate_emails = Reservation.archived.duplicate_email.map {|r| r.email }
    duplicate_emails.each do |e|
      final = Reservation.archived.where(email: e).order(:created_at).last
      Reservation.archived.where(email: e).where.not(id: final.id).destroy_all
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

  def self.process_post_event_reservations!
    # destroy unsubscribed archived (we don't destroy unsubscribed current)
    Reservation.archived.unsubscribed.where(no_emails: true).destroy_all
    Rails.logger.info "Destroyed unsubscribed."

    # destroy unconfirmed
    Reservation.unconfirmed.destroy_all
    Rails.logger.info "Destroyed unconfirmed reservations."

    # destroy older than 4 years (not pariticipated in last 4 annual events)
    Reservation.archived.each do |r|
      if r.events.any?
        r.destroy if r.events.order(:date).last.date < ( Time.now - 4.years )
      end
    end

    # merge records, deleting older duplicate archived records
    Reservation.merge_unarchived_with_archived!
    Rails.logger.info "Archived all data."

    # reset marketing emails
    Reservation.clear_email_campaign_flags!
  end

  def last_missing_tree_status
    logs.missing_tree_status.order(:created_at).last
  end

  def last_missing_tree_sms
    logs.missing_tree_sms.order(:created_at).last
  end

  def last_missing_tree_email
    logs.missing_tree_email.order(:created_at).last
  end

  def self.clear_email_campaign_flags!
    Reservation.update_all(
      is_marketing_email_1_sent: false,
      is_marketing_email_2_sent: false,
      is_pickup_reminder_email_sent: false,
      is_confirmed_reservation_email_sent: false,
      is_missing_tree_email_sent: false
      )
  end

  private

  def merge_in_archived!
    if existing_archived = Reservation.archived.where(email: self.email).where.not(id: self.id).first
      self.update_column(:years_recycling,  self.years_recycling + existing_archived.years_recycling)
      existing_archived.donations.update_all(reservation_id: self.id)
      existing_archived.destroy
    else
      nil
    end
  end

  def normalize_phone!
    self.phone = Phonelib.parse(phone).full_e164.presence if phone.present?
  end

  def downcase_email!
    self.email = self.email.downcase
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
    logs.create(category: 'missing_tree_status', message: 'Pickup attempted. Tree not found.')
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
