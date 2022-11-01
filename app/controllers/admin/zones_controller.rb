class Admin::ZonesController < Admin::AdminController
  before_action :set_zone, only: %i[ show edit update destroy map ]

  def index
    @zones = Zone.all
  end

  def show
  end

  def new
    @zone = Zone.new
  end

  def edit
  end

  def create
    @zone = Zone.new(zone_params)

    if @zone.save
      redirect_to admin_zones_url, notice: "Zone was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @zone.update(zone_params)
      redirect_to admin_zones_url, notice: "Zone was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @zone.destroy

    redirect_to admin_zones_url, notice: "Zone was successfully destroyed."
  end

  def map
    @zone_reservations = Reservation.geocoded.where(zone: @zone).map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
    redirect_to admin_zones_path, notice: 'No reservations in that Zone.' unless @zone_reservations.any?
    average_lat = @zone_reservations.map {|l| l[0]}.sum / @zone_reservations.length
    average_lon = @zone_reservations.map {|l| l[1]}.sum / @zone_reservations.length
    @zone_center_reservation = [average_lat, average_lon]
  end

  private
    def set_zone
      @zone = Zone.find(params[:id] || params[:zone_id])
    end

    def zone_params
      params.require(:zone).permit(:name, :street, :city, :state, :country, :distance)
    end
end
