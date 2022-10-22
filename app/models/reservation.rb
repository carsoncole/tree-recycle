class Reservation < ApplicationRecord

  validates :name, :street, presence: true
  geocoded_by :address
  after_validation :geocode

  def initialize(args)
    super
    self.country = Setting&.first&.default_country if Setting.first
    self.city = Setting&.first&.default_city if Setting.first
    self.state = Setting&.first&.default_state if Setting.first
  end

  def address
    [street, city, state, country].compact.join(', ')
  end
end
