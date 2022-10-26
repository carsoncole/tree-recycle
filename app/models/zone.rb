class Zone < ApplicationRecord
  has_many :reservations, dependent: :nullify

  validates :name, :street, :city, :country, :distance, presence: true

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.street_changed? }

  def initialize(args)
    super
    self.country = 'United States'
    self.city = Setting&.first&.default_city if Setting.first
    self.state = Setting&.first&.default_state if Setting.first
  end

  def address
    [street, city, state, country].compact.join(', ')
  end

  def coordinates
    if geocoded?
      [latitude, longitude]
    end
  end

end
