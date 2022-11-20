class Zone < ApplicationRecord
  include Geocodable

  default_scope { order(name: :asc) }

  has_many :drivers, dependent: :nullify
  has_many :routes, dependent: :nullify
  has_many :reservations, through: :routes
  belongs_to :leader, class_name: 'Driver', optional: true

  validates :name, presence: true
end
