class Driver < ApplicationRecord
  belongs_to :zone, optional: true

  scope :unzoned, -> { where(zone_id: nil) }

  validates :phone, presence: true
end
