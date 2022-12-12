module Geocodable
  extend ActiveSupport::Concern

  included do
    geocoded_by :address

    validates :street, :city, :state, :country, presence: true

    attribute :city, :string, default: DEFAULT_CITY
    attribute :state, :string, default: DEFAULT_STATE
    attribute :country, :string, default: DEFAULT_COUNTRY

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
      if self.class == Reservation
        return unless self.is_geocoded?
      end
      self.latitude = nil
      self.longitude = nil
      self.house_number = nil
      self.street_name = nil
      self.route_id = nil if self.class == Reservation && self.is_routed
      if Geocoder.config.lookup == :nominatum
        begin
          results = Geocoder.search(self.address)
          self.latitude = results.as_json[0]["data"]["lat"]
          self.longitude = results.as_json[0]["data"]["lon"]
          self.house_number = results.as_json[0]["data"]["address"]["house_number"]
          self.street_name = results.as_json[0]["data"]["address"]["road"]
        rescue
          geocode
        end
      elsif Geocoder.config.lookup == :amazon_location_service

        # multiple results (seems like 2) can be return, the second being a coordinate of just the street, not number
        begin
          results = Geocoder.search(self.address)

          if results.count == 1
            geocode
          elsif results.count == 2 && results.as_json[0]["place"]["address_number"].present?
            result = results.as_json[0]["place"]

            self.latitude = result["geometry"]["point"][1]
            self.longitude = result["geometry"]["point"][0]
            self.house_number = result["geometry"]["address_number"]
            self.street_name = result["street"]            
          end
        rescue
          # geocode
        end        
      end
    end

  end
end
