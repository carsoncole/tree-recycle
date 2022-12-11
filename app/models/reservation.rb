require 'csv'
#OPTIMIZE improve route assignments
class Reservation < ApplicationRecord
  include Geocodable

  # default_scope { order(:street_name, :house_number) }

  belongs_to :route, optional: true
  has_one :zone, through: :route
  has_many :donations, dependent: :nullify
  has_many :logs, dependent: :destroy

  enum :donation, { online_donation: 1, cash_or_check_donation: 2, no_donation: 3 }
  enum :status, { unconfirmed: 0, pending_pickup: 1, picked_up: 2, missing: 3, cancelled: 4, archived: 99 }, default: :unconfirmed

  enum :heard_about_source, { newspaper: 8, facebook: 1, safeway_flyer: 6, christmas_tree_lot_flyer: 7, nextdoor: 2,  roadside_sign: 3, 'Town & Country reader board': 9, word_of_mouth: 4, email_reminder_from_us: 5, other: 99 }

  scope :pending, -> { where.not(status: ['archived', 'cancelled', 'unconfirmed'])}
  scope :unrouted, -> { where(route_id: nil) }
  scope :routed, -> { where.not(route_id: nil) }

  validates :name, :email, presence: true

  attribute :is_routed, :boolean, default: true

  after_validation :route!, if: ->(obj){ obj.geocoded? && obj.is_routed? && (obj.latitude_changed? && (obj.persisted? || obj.route_id.nil?)) }

  # email delivery
  after_save :send_confirmed_reservation_email!, if: -> (obj){ obj.pending_pickup? && obj.saved_change_to_status? }
  after_update :send_cancelled_reservation_email!, if: -> (obj){ obj.cancelled? && obj.saved_change_to_status? }


  # sms delivery
  after_commit :send_missing_sms!, if: ->(obj){ obj.missing? && obj.phone.present? && obj.saved_change_to_status? && obj.persisted? }

  # logging
  after_commit :log_unconfirmed!, if: ->(obj){ obj.unconfirmed? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_pending_pickup!, if: ->(obj){ obj.pending_pickup? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_picked_up!, if: ->(obj){ obj.picked_up? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_cancelled!, if: ->(obj){ obj.cancelled? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_missing!, if: ->(obj){ obj.missing? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_archived!, if: ->(obj){ obj.archived? && obj.saved_change_to_status? && obj.persisted? }

  def self.open?
    Setting.first_or_create.is_reservations_open?
  end

  def self.process_all_routes!
    all.each do |r|
      r.route!
      r.save
    end
  end

  def total_donations_amount
    donations.sum(:amount)
  end

  def online_donated?
    donations.any?
  end

  def routed?
    route.present?
  end

  def route!
    Router.new(self).route!
  end

  def send_confirmed_reservation_email!
    ReservationsMailer.with(reservation: self).confirmed_reservation_email.deliver_later
  end

  def send_cancelled_reservation_email!
    ReservationsMailer.with(reservation: self).cancelled_reservation_email.deliver_later
  end

  def send_missing_sms!
    message = "Hello, it's Bainbridge Tree Recycle! We can't find your tree for pickup. "
    message += "Possibly your tree has not been put out or in an easily observable location. Please reply to this text message ASAP"
    message += ", or call us at #{ Setting&.first&.contact_phone }," if Setting&.first&.contact_phone.present?
    message += " if you would like us to  attempt a second pick-up of your tree today. "
    Sms.new.send_with_object(self, message)
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

  # sends hello email to ARCHIVED reservations that have not been previously sent this email.
  def self.send_hello_email!
    archived.each do |archived_reservation|
      UserMailer.with(reservation: archived_reservation).hello_email.deliver_later
    end
  end

  # sends last call email to ARCHIVED reservations that have not been previously sent this email.
  def self.send_last_call_email!
    archived.each do |archived_reservation|
      UserMailer.with(reservation: archived_reservation).last_call_email.deliver_later
    end
  end

  def self.archive_all_unarchived!
    Reservation.not_archived.update_all(status: :archived)
  end

  def self.destroy_all_archived!
    Reservation.archived.destroy_all
  end

  def self.merge_unarchived_with_archived!
    Reservation.not_archived.not_unconfirmed.each do |r|
      Reservation.archived.where(email: r.email).destroy_all
      r.archived!
    end
  end

  def self.destroy_reservations_older_than_months(months)
    Reservation.where("created_at > ?", Time.now + months.to_i.months).destroy_all
  end

  def self.reservations_to_send_marketing
    # collect Archived,
    #    not also in not_archived
    #    not sent marketing email 1
    #    not no_emails
    #    max count of email_batch_quantity
    reservations_to_send =
      Reservation.archived.
      where.not(email:  Reservation.not_archived.map{ |r| r.email } ).
      where(is_marketing_email_1_sent: false).
      where(no_emails: false).
      order(:email)
  end


  private

  def log_unconfirmed!
    logs.create(message: "Reservation unconfirmed")
  end

  def log_pending_pickup!
    logs.create(message: 'Tree is pending pickup')
  end

  def log_picked_up!
    logs.create(message: 'Tree picked up')
  end

  def log_missing!
    logs.create(message: 'Pickup attempted. Tree not found.')
  end

  def log_cancelled!
    logs.create(message: 'Reservation cancelled')
  end

  def log_archived!
    logs.create(message: 'Reservation archived')
  end

end
