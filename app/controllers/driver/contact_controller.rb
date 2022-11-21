class Driver::ContactController < Driver::DriverController
  def index
    @zone_leaders = Driver.includes(:zone).order('zones.name')
  end
end
