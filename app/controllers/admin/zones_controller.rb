class Admin::ZonesController < Admin::AdminController
  before_action :set_zone, only: %i[ show edit update destroy ]

  def index
    @zones = Zone.includes(:routes).all.order(:name)
    @pending_pickups_count = Reservation.pending_pickup.routed.count
    @missing_count = Reservation.missing.count
    @picked_up_count = Reservation.picked_up.count
    @all_zones = true if params[:all_zones]
  end

  def new
    @zone = Zone.new
  end

  def edit
  end

  def create
    @zone = Zone.new(zone_params)

    if current_user.editor? || current_user.administrator?

      respond_to do |format|
        if @zone.save
          format.html { redirect_to admin_zones_url, notice: "Zone was successfully created." }
          format.json { render :show, status: :created, location: @zone }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @zone.errors, status: :unprocessable_entity }
        end
      end
    else
      render :new, status: :unauthorized
    end   
  end

  def update
    if current_user.editor? || current_user.administrator?
      if @zone.update(zone_params)
        redirect_to admin_zones_url, notice: "Zone was successfully updated."
      else
        redirect_to admin_routing_url, alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
      end
    else
      redirect_to admin_routing_url, alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
    end    
  end

  def destroy
    if current_user.editor? || current_user.administrator?

      @zone.destroy

      respond_to do |format|
        format.html { redirect_to admin_zones_url, notice: "Zone was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to admin_routing_url, alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
    end
  end

  private
    def set_zone
      @zone = Zone.find(params[:id])
    end

    def zone_params
      params.require(:zone).permit(:name, :street, :city, :state, :country)
    end
end
