class Driver::TeamsController < Driver::DriverController
  def index
    @teams = Team.all.order(:name)
  end

  def show
    @team = Team.find(params[:id])
    @drivers = @team.drivers.order(:name)
    @routes = @team.routes
  end
end
