
#TODO create manually reservation entry proces
class Admin::ReservationsController < Admin::AdminController
  before_action :set_reservation, except: %i[ new index search process_all_routes map]


  def index
    if params[:route_id]
      @pagy, @reservations = pagy(Reservation.includes(:route).order(:street_name, :house_number).where(route_id: params[:route_id]))
    elsif params[:picked_up]
      @pagy, @reservations = pagy(Reservation.picked_up.includes(:route).order(:street_name, :house_number))
    elsif params[:unrouted]
      @pagy, @reservations = pagy(Reservation.unrouted.order(:street_name, :house_number))
    elsif params[:cancelled]
      @pagy, @reservations = pagy(Reservation.cancelled.includes(:route).order(:street_name, :house_number))
    elsif params[:missing]
      @pagy, @reservations = pagy(Reservation.missing.includes(:route).order(:street_name, :house_number))
    elsif params[:all]
      @pagy, @reservations = pagy(Reservation.not_archived.includes(:route).order(:street_name, :house_number).order(created_at: :asc))
    elsif params[:archived]
      @pagy, @reservations = pagy(Reservation.archived.includes(:route).order(:street_name, :house_number).order(created_at: :asc))
    else
      @pagy, @reservations = pagy(Reservation.pending_pickup.includes(:route).order(:street_name, :house_number))

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
    @donations = @reservation.donations
  end

  def destroy
    if Reservation.open?
      @reservation.cancelled!
      redirect_back(fallback_location: admin_root_path, notice: "Reservation was successfully cancelled.")
    else
      redirect_back(fallback_location: admin_root_path, alert: "Reservations are no longer changeable. #{view_context.link_to('Contact us', '/questions')} if you have questions.") unless Reservation.open?
    end
  end


  def map
    @reservations = Reservation.geocoded.map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
  end

  def search
    @pagy, @reservations = pagy(Reservation.where("name ILIKE ? OR street ILIKE ?", "%" + Reservation.sanitize_sql_like(params[:search]) + "%", "%" + Reservation.sanitize_sql_like(params[:search]) + "%"))
    render :index
  end

  def process_route
    @reservation.route!
    redirect_back(fallback_location: admin_root_path)
  end

  def process_all_routes
    Reservation.process_all_routes!
    redirect_to admin_reservations_path
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :notes, :latitude, :longitude, :route_id, :status)
    end
end
