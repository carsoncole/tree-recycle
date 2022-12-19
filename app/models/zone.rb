class Zone < ApplicationRecord
  include Geocodable

  default_scope { order(name: :asc) }

  has_many :routes, dependent: :nullify
  has_many :reservations, through: :routes
  has_many :drivers, through: :routes


  validates :name, presence: true
end
