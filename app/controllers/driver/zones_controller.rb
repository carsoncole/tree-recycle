class Driver::ZonesController < Driver::DriverController
  def index
    @zones = Zone.all.order(:name)
    render 'shared/zones/index'
  end

  def show
    @zone = Zone.find(params[:id])
    @drivers = @zone.drivers.order(:name)
    @routes = @zone.routes
    @total_pickups = @zone.reservations.pending_pickup.count
    render 'admin/zones/show'
  end
end
