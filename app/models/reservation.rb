class Reservation < ApplicationRecord

  def address
    [street, city, state, country].compact.join(', ')
  end
end
