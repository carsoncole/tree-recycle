class Team < ApplicationRecord
  has_many :drivers
  has_many :zones

  default_scope { order(name: :asc) }
end
