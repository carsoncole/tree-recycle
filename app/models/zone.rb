class Zone < ApplicationRecord
  has_many :drivers
  has_many :routes
  belongs_to :leader, class_name: 'Driver', optional: true

  validates :name, presence: true

  default_scope { order(name: :asc) }
end
