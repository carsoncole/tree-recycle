#TODO print stylesheets needed
class Driver::RoutesController < Driver::DriverController
  def show
    @route = Route.find(params[:id])
    @reservations = @route.reservations.pending
    flash[:notice] = "Reservation status changes are NOT enabled." unless helpers.setting.is_driver_site_enabled?
  end
end
