class Admin::RoutesController < Admin::AdminController
  before_action :set_route, only: %i[ edit update destroy map ]

  def new
    @route = Route.new
  end

  def edit
    @point = @route.points.build
    @points = @route.points
  end

  def create
    if current_user.editor? || current_user.administrator?
      @route = Route.new(route_params)

      if @route.save
        redirect_to admin_routing_url, notice: "Route was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to admin_routing_url, alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
    end
  end

  def update
    if current_user.editor? || current_user.administrator?
      if @route.update(route_params)
        redirect_to admin_routing_url, notice: "Route was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to admin_routing_url, alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
    end
  end

  def destroy
    if current_user.editor? || current_user.administrator?
      @route.destroy

      redirect_to admin_routing_url, notice: "Route was successfully destroyed."
    else
      redirect_to admin_routing_url, alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
    end
  end

# https://maps.google.com/maps?ll=-25.344016,131.035417&z=16&t=h&hl=en-US&gl=US&mapclient=apiv3&cid=4469685432667933103
# http://maps.apple.com/?daddr=1600+Amphitheatre+Pkwy,+Mountain+View+CA

  def map
    @route_reservations = Reservation.geocoded.where(route: @route).map{|r| [ "<a href=" + admin_reservation_url(r) + ">" + r.name + "</a>" + "<br />" + r.street +  "<br />" + "<a href='http://maps.apple.com/?daddr=" + r.address + "'>Directions</a><br />" + (r.picked_up? ? 'Picked up' : 'Ready'), r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
    redirect_to admin_routes_path, notice: 'No reservations in that Route.' unless @route_reservations.any?
    average_lat = @route_reservations.map {|l| l[1]}.sum / @route_reservations.length
    average_lon = @route_reservations.map {|l| l[2]}.sum / @route_reservations.length
    @route_center_reservation = [average_lat, average_lon]
  end

  private
    def set_route
      @route = Route.find(params[:id] || params[:route_id])
    end

    def route_params
      params.require(:route).permit(:name, :street, :city, :state, :country, :distance, :zone_id)
    end
end
