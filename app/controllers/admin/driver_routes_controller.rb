class Admin::DriverRoutesController < Admin::AdminController

  def create
    if current_user.administrator? || current_user.editor?
      @driver = Driver.find(params[:driver_route][:driver_id])
      DriverRoute.create(
        driver_id: params[:driver_route][:driver_id],
        route_id: params[:driver_route][:route_id]
        )
      redirect_to edit_admin_driver_path(@driver)
    else
      redirect_to admin_drivers_path, notice: 'Unauthorized. Editor or Administrator access is required.'
    end
  end

  def destroy
    if current_user.administrator? || current_user.editor?
      driver_route = DriverRoute.find(params[:id])
      driver_route.destroy
      redirect_to edit_admin_driver_path(driver_route.driver_id)
    else
      redirect_to admin_drivers_path, notice: 'Unauthorized. Editor or Administrator access is required.'
    end
  end

end