#TODO create zone reports for use on day of event
class Zone < ApplicationRecord
  default_scope { order(name: :asc) }

  has_many :reservations, dependent: :nullify
  belongs_to :team, optional: true

  validates :name, :street, :city, :country, :distance, presence: true

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.street_changed? && !(obj.latitude_changed? && obj.longitude_changed?)}

  def initialize(args)
    super
    self.country ||= 'United States'
    self.city = Setting&.first&.default_city.present? ?  Setting&.first&.default_city : 'Bainbridge Island'
    self.state = Setting&.first&.default_state.present? ?  Setting&.first&.default_state : 'Washington'
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
