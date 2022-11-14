#TODO status buttons need finishing
class Driver::DriversController < Driver::DriverController
  def index
    @drivers = Driver.all.order(:name)
  end

  def show
    @driver = Driver.find(params[:id])
  end
end
