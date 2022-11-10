class Zone < ApplicationRecord
  include Geocodable

  has_many :drivers
  has_many :routes
  has_many :reservations, through: :routes
  belongs_to :leader, class_name: 'Driver', optional: true

  validates :name, presence: true

  default_scope { order(name: :asc) }

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.street_changed? && !(obj.latitude_changed? && obj.longitude_changed?)}

end
