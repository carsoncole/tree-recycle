class Driver::ContactController < Driver::DriverController
  def index
    @zone_leaders = Driver.leader.includes(:zone).order('zones.name')
    @zones = Zone.all.includes(:drivers)
  end
end
