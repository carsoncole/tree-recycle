class Admin::ReservationsController < Admin::AdminController
  before_action :set_reservation, except: %i[ new index search process_all_zones map]


  def index
    if params[:zone_id]
      @pagy, @reservations = pagy(Reservation.order(:street_name, :house_number).where(zone_id: params[:zone_id]))
    elsif params[:picked_up]
      @pagy, @reservations = pagy(Reservation.picked_up.order(:street_name, :house_number))
    elsif params[:cancelled]
      @pagy, @reservations = pagy(Reservation.cancelled.order(:street_name, :house_number))
    elsif params[:missing]
      @pagy, @reservations = pagy(Reservation.missing.order(:street_name, :house_number))
    elsif params[:all]
      @pagy, @reservations = pagy(Reservation.not_archived.order(:street_name, :house_number).order(created_at: :asc))
    elsif params[:archived]
      @pagy, @reservations = pagy(Reservation.archived.order(:street_name, :house_number).order(created_at: :asc))
    else
      @pagy, @reservations = pagy(Reservation.pending_pickup.order(:street_name, :house_number))

    end
  end

  def edit
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to admin_reservation_url(@reservation)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @logs = @reservation.logs
    @statuses = Reservation.statuses.map {|key, value| key == "archived" ? nil : [key.titleize, key] }.compact
  end

  def map
    @reservations = Reservation.geocoded.map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
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
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :notes, :latitude, :longitude, :zone_id, :status)
    end
end
