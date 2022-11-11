module Geocodable
  extend ActiveSupport::Concern

  included do

    def address
      [street, city, state, country].compact.join(', ')
    end

    def coordinates
      if geocoded?
        [latitude, longitude]
      end
    end
  end
end
