class Admin::ZonesController < ApplicationController
  before_action :require_login
  before_action :set_zone, only: %i[ show edit update destroy ]

  # GET /admin/zones or /admin/zones.json
  def index
    @zones = Zone.all
  end

  # GET /admin/zones/1 or /admin/zones/1.json
  def show
  end

  # GET /admin/zones/new
  def new
    @zone = Zone.new
  end

  # GET /admin/zones/1/edit
  def edit
  end

  # POST /admin/zones or /admin/zones.json
  def create
    @zone = Zone.new(zone_params)

    if @zone.save
      redirect_to admin_zone_url(@zone), notice: "Zone was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/zones/1 or /admin/zones/1.json
  def update
    if @zone.update(zone_params)
      redirect_to admin_zone_url(@zone), notice: "Zone was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/zones/1 or /admin/zones/1.json
  def destroy
    @zone.destroy

    respond_to do |format|
      format.html { redirect_to admin_zones_url, notice: "Zone was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zone
      @zone = Zone.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def zone_params
      params.require(:zone).permit(:name, :street, :city, :state, :country, :distance)
    end
end
