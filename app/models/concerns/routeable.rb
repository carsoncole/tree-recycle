module Routeable
  extend ActiveSupport::Concern

  included do

    def route!
      set_route
      self.save
    end

    def set_route
    return unless is_routed? && geocoded?
    route_id = nil
    Route.all.each do |z|
      if z.polygon? && z.contains?(latitude, longitude)
        self.route_id = z.id
        self.is_route_polygon = true
        break
      end
      distance_to_new_route = distance_to(z.coordinates)
      if (route && distance_to_route > distance_to_new_route) || route.nil?
        self.route_id = z.id
        self.distance_to_route = distance_to_new_route
      end
      self.changed?
    end
    route
    end
  end
end
