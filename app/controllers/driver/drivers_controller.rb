class Driver::DriversController < Driver::DriverController
  def index
    @zones = Zone.all.includes(:drivers)
  end

  def show
    @driver = Driver.find(params[:id])
  end
end
