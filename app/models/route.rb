#TODO create route reports for use on day of event
class Route < ApplicationRecord
  default_scope { order(name: :asc) }

  has_many :reservations, dependent: :nullify
  belongs_to :team, optional: true

  validates :name, :street, :city, :country, :distance, presence: true

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.street_changed? && !(obj.latitude_changed? && obj.longitude_changed?)}

  def initialize(args)
    super
    setting = Setting&.first
    self.country ||= 'United States'
    self.city = setting&.default_city.present? ?  setting&.default_city : 'Bainbridge Island'
    self.state = setting&.default_state.present? ?  setting&.default_state : 'Washington'
    self.distance ||= 1
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
