class Router

  def initialize(obj)
    @obj = obj
  end

  def location
    @obj
  end

  def route!
    return unless location.is_routed?
    location.route_id = nil
    return unless location.geocoded?
    Route.all.each do |z|
      if z.polygon? && z.contains?(location.latitude, location.longitude)
        location.route_id = z.id
        location.is_route_polygon = true
        puts "*"*80
        break
        puts "&"*80
      else
        # puts z.coordinates
        distance_to_new_route = location.distance_to(z.coordinates)
        # puts distance_to_new_route
        if (location.route && location.distance_to_route > distance_to_new_route) || location.route.nil?
          location.route_id = z.id
          location.distance_to_route = distance_to_new_route
        end
      end
    end
    location.routed?
  end

  def zone!
    return unless location.is_zoned?
    location.zone_id = nil
    return unless location.geocoded?
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
