require 'csv'
#OPTIMIZE improve zone assignments
class Reservation < ApplicationRecord
  belongs_to :zone, optional: true
  has_many :logs, dependent: :destroy

  enum :status, { pending_pickup: 0, picked_up: 1, missing: 2, cancelled: 3, archived: 99 }

  validates :name, :street, :city, :state, :country, :email, presence: true
  geocoded_by :address
  after_validation :full_geocode, if: ->(obj){ obj.address.present? && obj.street_changed? && !(obj.latitude_changed? && obj.longitude_changed?)}

  after_create :send_confirmed_reservation_email!, if: -> (obj){ obj.pending_pickup? }
  after_update :send_cancelled_reservation_email!, if: -> (obj){ obj.saved_change_to_status? && obj.cancelled? }

  after_create :log_creation!
  after_update :log_cancellation!, if: ->(obj){ obj.cancelled? && obj.saved_change_to_status? }
  after_update :log_picked_up!, if: ->(obj){ obj.picked_up? && obj.saved_change_to_status? }
  after_update :log_missing!, if: ->(obj){ obj.missing? && obj.saved_change_to_status? }
  after_update :log_pending_pickup!, if: ->(obj){ obj.pending_pickup? && obj.saved_change_to_status? }

  def initialize(args)
    super
    self.country = Setting.first_or_create.default_country || 'United States'
    self.city = Setting&.first&.default_city.present? ?  Setting&.first&.default_city : 'Bainbridge Island'
    self.state = Setting&.first&.default_state.present? ?  Setting&.first&.default_state : 'Washington'
  end

  def self.open?
    Setting.first_or_create.is_reservations_open?
  end

  def address
    [street, city, state, country].compact.join(', ')
  end

  def short_address
    [street, city, state].compact.join(', ')
  end

  def self.process_all_zones!
    all.each do |r|
      r.process_zone!
    end
  end

  def donated?
    stripe_charge_amount.present? || is_cash_or_check?
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
  end

  def process_zone!
    return unless geocoded?

    Zone.all.each do |z|
      next if z == zone
      distance_to_new_zone = self.distance_to(z.coordinates)

      if (zone && distance_to_zone > distance_to_new_zone) || zone.nil?
        self.zone_id = z.id
        self.distance_to_zone = distance_to_new_zone
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
  def self.import
    Setting.first.update(is_emailing_enabled: false)
    CSV.foreach('tmp/tree_data.csv', headers: true) do |row|
      Reservation.create(name: row['full_name'], email: row['email'], street: row['pickup_address'], phone: row['phone'], notes: row['comment'], status: 'archived' )
    end
  end

  def coordinates
    if geocoded?
      [latitude, longitude]
    end
  end

  # sends hello email to ARCHIVED reservations that have not been previously sent this email.
  def self.send_hello_email!
    archived.each do |archived_reservation|
      UserMailer.with(reservation: archived_reservation).hello_email.deliver_now
    end
  end

  # sends last call email to ARCHIVED reservations that have not been previously sent this email.
  def self.send_last_call_email!
    archived.each do |archived_reservation|
      UserMailer.with(reservation: archived_reservation).last_call_email.deliver_now
    end
  end

  private

  def set_picked_up_at!
    self.picked_up_at = Time.now
  end

  def clear_picked_up_at!
    self.picked_up_at = nil
  end

  def set_is_missing_at!
    self.is_missing_at = Time.now
  end

  def clear_is_missing_at!
    self.is_missing_at = nil
  end

  def clear_is_missing!
    self.is_missing, self.is_missing_at = nil, nil
  end

  def clear_is_picked_up!
    self.is_picked_up, self.picked_up_at = nil, nil
  end

  def log_creation!
    logs.create(message: 'Reservation created')
  end

  def log_cancellation!
    logs.create(message: 'Reservation cancelled')
  end

  def log_picked_up!
    logs.create(message: 'Tree picked up')
  end

  def log_missing!
    logs.create(message: 'Pickup attempted. Tree not found.')
  end

  def log_pending_pickup!
    logs.create(message: 'Tree is pending pickup')
  end

end
