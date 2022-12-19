class Driver < ApplicationRecord
  has_many :driver_routes, dependent: :destroy
  has_many :routes, through: :driver_routes

  scope :unzoned, -> { where(zone_id: nil) }
  scope :leader, -> { where(is_leader: true) }

  validates :name, :phone, presence: true
end
