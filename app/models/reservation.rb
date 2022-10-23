class Reservation < ApplicationRecord
  belongs_to :zone, optional: true


  validates :name, :street, presence: true
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.street_changed? }

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
