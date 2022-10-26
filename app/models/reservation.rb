class Reservation < ApplicationRecord
  belongs_to :zone, optional: true


  scope :completed,  -> { where(is_completed: true) }
  scope :uncompleted, -> { where.nil(is_completed: false) }

  validates :name, :street, presence: true
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.street_changed? }

  def initialize(args)
    super
    self.country = Setting&.first&.default_country if Setting.first
    self.city = Setting&.first&.default_city if Setting.first
    self.state = Setting&.first&.default_state if Setting.first
  end

  def address
    [street, city, state, country].compact.join(', ')
  end

  def self.process_all_zones!
    all.each do |r|
      r.process_zone!
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
end
