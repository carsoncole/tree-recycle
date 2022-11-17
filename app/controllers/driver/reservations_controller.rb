class Driver::ReservationsController < Driver::DriverController
  def search
  end

  def map
    if params[:route_id]
      @route = Route.find(params[:route_id])
      @reservations = Reservation.pending_pickup.where(route: @route ).geocoded.map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
    else
      @reservations = Reservation.pending_pickup.geocoded.map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
    end
  end

  def update
    @reservation = Reservation.find(params[:id])
    case params[:status]
    when  'picked_up'
      @reservation.picked_up!
    when 'missing'
      @reservation.missing!
    when 'pending_pickup'
      @reservation.pending_pickup!
    end
    redirect_to driver_route_path(@reservation.route)
  end
end
