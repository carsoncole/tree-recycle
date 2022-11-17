class Driver::ZonesController < Driver::DriverController
  def index
    @zones = Zone.all.order(:name)
  end
end
