require 'csv'
#OPTIMIZE improve zone assignments
class Reservation < ApplicationRecord
  belongs_to :zone, optional: true


  scope :completed,  -> { where(is_confirmed: true) }
  scope :uncompleted, -> { where(is_confirmed: [nil, false]) }

  validates :name, :street, :city, :state, :country, :email, presence: true
  geocoded_by :address
  after_validation :full_geocode, if: ->(obj){ obj.address.present? and obj.street_changed? }
  after_save :send_confirmation_email!, if: -> (obj){ obj.is_confirmed and obj.saved_change_to_is_confirmed? }

  def initialize(args)
    super
    self.country = Setting.first_or_create.default_country || 'United States'
    self.city = Setting&.first&.default_city || 'Bainbridge Island'
    self.state = Setting&.first&.default_state || 'Washington'
  end

  def self.open?
    Setting&.first&.is_reservations_open?
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

  def send_confirmation_email!
    ReservationsMailer.with(reservation: self).confirmed_reservation_email.deliver_later
  end

  # method to import data from existing tree recycle system csv export
  def self.import
    CSV.foreach('tmp/tree_data.csv', headers: true) do |row|
      Reservation.create(name: row['full_name'], email: row['email'], street: row['pickup_address'], is_confirmed: true, phone: row['phone'], notes: row['comment'] )
    end
  end
end
