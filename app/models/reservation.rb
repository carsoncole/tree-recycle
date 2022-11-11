require 'csv'
#OPTIMIZE improve route assignments
#FIXME sending of confirmation email on create/update of pending status
class Reservation < ApplicationRecord
  include Geocodable

  default_scope { order(:street_name, :house_number) }

  belongs_to :route, optional: true

  has_many :donations
  has_many :logs, dependent: :destroy

  enum :status, { unconfirmed: 0, pending_pickup: 1, picked_up: 2, missing: 3, cancelled: 4, archived: 99 }

  scope :pending, -> { where.not(status: ['archived', 'unconfirmed'])}

  validates :name, :street, :city, :state, :country, :email, presence: true
  geocoded_by :address
  after_validation :full_geocode, if: ->(obj){ obj.address.present? && obj.street_changed? && !(obj.latitude_changed? && obj.longitude_changed?) }

  after_create :send_confirmed_reservation_email!, if: -> (obj){ obj.pending_pickup? }
  after_update :send_confirmed_reservation_email!, if: -> (obj){ obj.pending_pickup? && obj.saved_change_to_status? }
  after_update :send_cancelled_reservation_email!, if: -> (obj){ obj.cancelled? && obj.saved_change_to_status? }

  after_create :log_creation!
  after_create :log_pending_pickup!, if: ->(obj){ obj.pending_pickup? }
  after_update :log_pending_pickup!, if: ->(obj){ obj.pending_pickup? && obj.saved_change_to_status? }
  after_update :log_picked_up!, if: ->(obj){ obj.picked_up? && obj.saved_change_to_status? }
  after_update :log_cancellation!, if: ->(obj){ obj.cancelled? && obj.saved_change_to_status? }
  after_update :log_missing!, if: ->(obj){ obj.missing? && obj.saved_change_to_status? }

  after_create :route!, if: ->(obj){ obj.geocoded? }
  after_update :route!, if: ->(obj){ obj.geocoded? && obj.saved_change_to_latitude? }

  def initialize(args)
    super
    self.country = Setting.first_or_create.default_country || 'United States'
    self.city = Setting&.first&.default_city.present? ?  Setting&.first&.default_city : 'Bainbridge Island'
    self.state = Setting&.first&.default_state.present? ?  Setting&.first&.default_state : 'Washington'
  end

  def self.open?
    Setting.first_or_create.is_reservations_open?
  end

  def short_address
    [street, city, state].compact.join(', ')
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

  def full_geocode
    begin
      self.latitude = nil
      self.longitude = nil
      self.house_number = nil
      self.street_name = nil
      results = Geocoder.search(self.address)
      self.latitude = results.as_json[0]["data"]["lat"]
      self.longitude = results.as_json[0]["data"]["lon"]
      self.house_number = results.as_json[0]["data"]["address"]["house_number"]
      self.street_name = results.as_json[0]["data"]["address"]["road"]
    rescue
      geocode
    end
    self.route_id = nil
  end

  def route!
    return unless geocoded?

    Route.all.each do |z|
      next if z == route
      distance_to_new_route = self.distance_to(z.coordinates)

      if (route && distance_to_route > distance_to_new_route) || route.nil?
        self.route_id = z.id
        self.distance_to_route = distance_to_new_route
      end
    end
    save
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

  private

  def log_creation!
    logs.create(message: 'Reservation created')
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

  def log_cancellation!
    logs.create(message: 'Reservation cancelled')
  end

end
