#TODO print stylesheets needed
class Driver::RoutesController < Driver::DriverController
  def index
    @routes = Route.all
  end

  def show
    @route = Route.find(params[:id])
    @reservations = @route.reservations.order(:street_name)
  end
end
