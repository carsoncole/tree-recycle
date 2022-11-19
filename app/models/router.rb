class Router

  def initialize(obj)
    @obj = obj
  end

  def location
    @obj
  end

  def route!
    return unless location.geocoded?
    location.route_id = nil
    Route.all.each do |z|
      # puts z.coordinates
      distance_to_new_route = location.distance_to(z.coordinates)
      # puts distance_to_new_route
      if (location.route && location.distance_to_route > distance_to_new_route) || location.route.nil?
        location.route_id = z.id
        location.distance_to_route = distance_to_new_route
      end
    end
    location.routed?
  end

  def zone!
    return unless location.geocoded?
    location.zone_id = nil
    Zone.all.each do |z|
      # puts z.coordinates
      distance_to_new_zone = location.distance_to(z.coordinates)
      # puts distance_to_new_zone
      if (location.zone && location.distance_to_zone > distance_to_new_zone) || location.zone.nil?
        location.zone_id = z.id
        location.distance_to_zone = distance_to_new_zone
      end
    end
  end

end
