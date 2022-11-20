class Route < ApplicationRecord
  include Geocodable

  default_scope { order(name: :asc) }

  has_many :reservations, dependent: :nullify
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
end
