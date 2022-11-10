class Driver::ReservationsController < Driver::DriverController
  def search
  end

  def map
    @route = Route.find(params[:route_id])
  end
end
