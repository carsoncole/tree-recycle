class Driver::ReservationsController < Driver::DriverController
  def search
  end

  def map
    @route = Route.find(params[:route_id])
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
