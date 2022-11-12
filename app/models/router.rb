class Router
  def initialize(reservation)
    @reservation = reservation
  end

  def reservation
    @reservation
  end


  def route!
    return unless reservation.geocoded?
    Route.all.each do |z|
      next if z == reservation.route
      distance_to_new_route = reservation.distance_to(z.coordinates)

      if (reservation.route && reservation.distance_to_route > distance_to_new_route) || reservation.route.nil?
        reservation.route_id = z.id
        reservation.distance_to_route = distance_to_new_route
      end
    end
    # reservation.save
  end

end
