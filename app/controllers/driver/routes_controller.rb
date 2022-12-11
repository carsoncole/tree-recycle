class Driver::RoutesController < Driver::DriverController
  def show
    @route = Route.find(params[:id])
    @reservations = @route.reservations.pending
    flash[:notice] = "Reservation status changes are NOT enabled." unless helpers.setting.is_driver_site_enabled?
    respond_to do |format|
      format.html
      format.pdf do 
        render pdf: "file_name",
        template: "driver/routes/show",
        page_size: 'Letter',
        orientation: "Landscape"
      end
    end
  end
end
