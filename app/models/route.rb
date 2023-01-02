class Route < ApplicationRecord
  include Geocodable

  default_scope { order(name: :asc) }

  has_many :reservations, dependent: :nullify

  has_many :driver_routes, dependent: :destroy
  has_many :drivers, through: :driver_routes
  has_many :points, dependent: :destroy

  belongs_to :zone, optional: true

  validates :name, presence: true

  scope :unzoned, -> { where(zone_id: nil) }

  after_validation :zone!, if: ->(obj){ obj.geocoded? && obj.is_zoned? && (obj.latitude_changed? && (obj.persisted? || obj.zone_id.nil?)) }

  attribute :is_zoned, :boolean, default: true

  def name_with_zone
    (zone&.name || 'No Zone') + ' / ' + self&.name
  end

  def zone!
    Router.new(self).zone!
  end

  def polygon?
    points.any? && points.count > 3
  end

  def contains?(lat, lon)
    return false unless polygon?
    polygon_array = points.order(:order).map {|point| Geokit::LatLng.new(point.latitude, point.longitude)}
    polygon = Geokit::Polygon.new(polygon_array)
    point = Geokit::LatLng.new(lat, lon)
    polygon.contains?(point)
  end
end
