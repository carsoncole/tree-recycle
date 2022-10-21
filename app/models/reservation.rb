class Reservation < ApplicationRecord

  validates :name, :street_1, presence: true
  geocoded_by :address
  after_validation :geocode

  def initialize(args)
    super
    self.country = 'United States'
  end

  def address
    [street_1, city, state, country].compact.join(', ')
  end
end