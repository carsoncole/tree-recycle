#TODO print stylesheets needed
class Driver::ZonesController < Driver::DriverController
  def index
    @zones = Zone.all
  end

  def show
    @zone = Zone.find(params[:id])
    @reservations = @zone.reservations.order(:street_name)
  end
end
