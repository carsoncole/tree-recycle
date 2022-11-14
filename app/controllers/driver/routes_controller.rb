#TODO print stylesheets needed
class Driver::RoutesController < Driver::DriverController
  def index
    @routes = Route.all
    render 'shared/routes/index'
  end

  def show
    @route = Route.find(params[:id])
    @reservations = @route.reservations.not_archived
  end
end
