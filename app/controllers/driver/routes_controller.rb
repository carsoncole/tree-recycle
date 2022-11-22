#TODO print stylesheets needed
class Driver::RoutesController < Driver::DriverController
  def show
    @route = Route.find(params[:id])
    @reservations = @route.reservations.pending
  end
end
