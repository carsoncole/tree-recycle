module Geocodable
  extend ActiveSupport::Concern

  included do
    geocoded_by :address

    validates :street, :city, :state, :country, presence: true

    attribute :city, :string, default: 'Bainbridge Island'
    attribute :state, :string, default: 'Washington'
    attribute :country, :string, default: 'United States'

    # geocoding and routing
    before_validation :full_geocode!, if: ->(obj){ obj.address.present? && obj.street_changed? && !(obj.latitude_changed? && obj.longitude_changed?) }

    def address
      [street, city, state, country].compact.join(', ')
    end

    def short_address
      [street, city, state].compact.join(', ')
    end

    def coordinates
      if geocoded?
        [latitude, longitude]
      end
    end

    def full_geocode!
      begin
        self.latitude = nil
        self.longitude = nil
        self.house_number = nil
        self.street_name = nil
        results = Geocoder.search(self.address)
        self.latitude = results.as_json[0]["data"]["lat"]
        self.longitude = results.as_json[0]["data"]["lon"]
        self.house_number = results.as_json[0]["data"]["address"]["house_number"]
        self.street_name = results.as_json[0]["data"]["address"]["road"]
      rescue
        geocode
      end
    end

  end
end
