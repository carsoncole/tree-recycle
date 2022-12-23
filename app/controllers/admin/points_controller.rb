class Admin::PointsController < Admin::AdminController
  def create
    point = Point.create(point_params)
    @route = Route.find(params[:point][:route_id])
    redirect_to edit_admin_route_path(@route)
  end

  def edit
    @point = Point.find(params[:id])
  end


  def update
    point = Point.find(params[:id])
    @route = point.route

    if point.update(point_params)
      redirect_to edit_admin_route_path(@route)
    else
      redirect_to edit_admin_route_path(@route), notice: 'There was an error updating the point.'
    end
  end

  def destroy
    point = Point.find(params[:id])
    point.destroy
    redirect_to edit_admin_route_path(point.route)    
  end

  private

  def point_params
    params.require(:point).permit(:route_id, :latitude, :longitude, :order)
  end
end

