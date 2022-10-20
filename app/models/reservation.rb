class Reservation < ApplicationRecord

  validates :name, presence: true
  validates :street_1, presence: true

  def initialize(args)
    super
    self.country = 'United States'
  end

  def address
    [street, city, state, country].compact.join(', ')
  end
end
