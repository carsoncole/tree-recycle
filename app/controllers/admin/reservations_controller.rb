class Admin::ReservationsController < Admin::AdminController
  before_action :set_reservation, except: %i[ new index search process_all_zones map]


  def index
    if params[:zone_id]
      @pagy, @reservations = pagy(Reservation.completed.order(:street_name, :house_number).where(zone_id: params[:zone_id]).order(created_at: :asc))
    elsif params[:uncompleted]
      @pagy, @reservations = pagy(Reservation.uncompleted.order(:street_name, :house_number).where(zone_id: params[:zone_id]).order(created_at: :asc))
    else
      @pagy, @reservations = pagy(Reservation.completed.order(:street_name, :house_number).order(created_at: :asc))
    end
  end

  def edit
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to admin_reservation_url(@reservation), notice: "Reservation was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def map
  end

  def search
    @pagy, @reservations = pagy(Reservation.where("name ILIKE ? OR street ILIKE ?", "%" + Reservation.sanitize_sql_like(params[:search]) + "%", "%" + Reservation.sanitize_sql_like(params[:search]) + "%"))
    render :index
  end

  def process_zone
    @reservation.process_zone!
    redirect_to admin_reservations_path
  end

  def process_all_zones
    Reservation.process_all_zones!
    redirect_to admin_reservations_path
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :latitude, :longitude, :zone_id)
    end
end
