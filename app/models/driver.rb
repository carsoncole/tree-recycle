class Driver < ApplicationRecord
  belongs_to :zone, optional: true

  scope :unzoned, -> { where(zone_id: nil) }
  scope :leader, -> { where(is_leader: true) }

  validates :name, :phone, presence: true
end
