class Admin::ZonesController < Admin::AdminController
  before_action :set_zone, only: %i[ show edit update destroy ]

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

  private
    def set_zone
      @zone = Zone.find(params[:id])
    end

    def zone_params
      params.require(:zone).permit(:name, :street, :city, :state, :country, :distance)
    end
end
