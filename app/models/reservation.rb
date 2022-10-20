class Reservation < ApplicationRecord


  def initialize(args)
    super
    self.country = 'United States'
  end

  def address
    [street, city, state, country].compact.join(', ')
  end
end
