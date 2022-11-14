#TODO status buttons need finishing
class Driver::DriversController < Driver::DriverController
  def index
    @drivers = Driver.all.order(:name)
    render 'shared/drivers/index'
  end

  def show
    @driver = Driver.find(params[:id])
  end
end
