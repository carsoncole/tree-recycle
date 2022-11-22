require 'csv'
#OPTIMIZE improve route assignments
class Reservation < ApplicationRecord
  include Geocodable

  default_scope { order(:street_name, :house_number) }

  belongs_to :route, optional: true
  has_one :zone, through: :route
  has_many :donations, dependent: :nullify
  has_many :logs, dependent: :destroy

  enum :status, { unconfirmed: 0, pending_pickup: 1, picked_up: 2, missing: 3, cancelled: 4, archived: 99 }, default: :unconfirmed

  enum :heard_about_source, { facebook: 1, nextdoor: 2, roadside_sign: 3, troop_1565_flyer_at_time_of_tree_purchase: 3, word_of_mouth: 4, email_reminder_from_last_year: 5, other: 99 }

  scope :pending, -> { where.not(status: ['archived', 'cancelled', 'unconfirmed'])}
  scope :unrouted, -> { where(route_id: nil) }
  scope :routed, -> { where.not(route_id: nil) }

  validates :name, :email, presence: true

  attribute :is_routed, :boolean, default: true

  after_validation :route!, if: ->(obj){ obj.geocoded? && obj.is_routed? && (obj.latitude_changed? && (obj.persisted? || obj.route_id.nil?)) }

  # email delivery
  after_save :send_confirmed_reservation_email!, if: -> (obj){ obj.pending_pickup? && obj.saved_change_to_status? }
  after_update :send_cancelled_reservation_email!, if: -> (obj){ obj.cancelled? && obj.saved_change_to_status? }

  # logging
  after_commit :log_unconfirmed!, if: ->(obj){ obj.unconfirmed? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_pending_pickup!, if: ->(obj){ obj.pending_pickup? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_picked_up!, if: ->(obj){ obj.picked_up? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_cancelled!, if: ->(obj){ obj.cancelled? && obj.saved_change_to_status? && obj.persisted? }
  after_commit :log_missing!, if: ->(obj){ obj.missing? && obj.saved_change_to_status? && obj.persisted? }

  def self.open?
    Setting.first_or_create.is_reservations_open?
  end

  def self.process_all_routes!
    all.each do |r|
      r.route!
    end
  end

  def donated?
    stripe_charge_amount.present? || is_cash_or_check?
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

  # method to import data from existing tree recycle system csv export
  def self.import(file)
    Setting.first.update(is_emailing_enabled: false)
    CSV.foreach(file.path, headers: true) do |row|
      Reservation.create(name: row['full_name'], email: row['email'], street: row['pickup_address'], phone: row['phone'], notes: row['comment'], latitude: row['lat'], longitude: row['lng'], house_number: row['house'], street_name: row['street'], route_name: row['route'], status: 'archived' )
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

  def self.archive_all!
    Reservation.not_archived.update_all(status: :archived)
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

end
