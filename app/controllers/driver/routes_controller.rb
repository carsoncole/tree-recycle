class Driver::RoutesController < Driver::DriverController
  def index
    @zones = Zone.includes(:routes).order(:name)

    respond_to do |format|
      format.html
      format.pdf do 
        render pdf: "TreeRecycle Routes Report #{ Time.now.strftime('%^b-%d %H-%M')}",
        template: "driver/routes/index",
        page_size: 'Letter',
        orientation: "Landscape"
      end
    end
  end

  def show
    @route = Route.find(params[:id])
    flash[:notice] = "Reservation status changes are NOT enabled." unless helpers.setting.is_driver_site_enabled?
    respond_to do |format|
      format.html
      format.pdf do 
        render pdf: "TreeRecycle Route Report-#{@route.name}-#{ Time.now.strftime('%^b-%d %H-%M')}",
        template: "driver/routes/show",
        page_size: 'Letter',
        orientation: "Landscape"
      end
    end
  end
end
