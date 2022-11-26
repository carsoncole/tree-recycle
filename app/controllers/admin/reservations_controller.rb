class Admin::ReservationsController < Admin::AdminController
  before_action :set_reservation, except: %i[ new index search process_all_routes map archive_all]


  def index
    if params[:route_id]
      @pagy, @reservations = pagy(Reservation.not_archived.includes(:route).order(:street_name, :house_number).where(route_id: params[:route_id]))
    elsif params[:picked_up]
      @pagy, @reservations = pagy(Reservation.not_archived.picked_up.includes(:route).order(:street_name, :house_number))
    elsif params[:unrouted]
      @pagy, @reservations = pagy(Reservation.not_archived.unrouted.order(:street_name, :house_number))
    elsif params[:cancelled]
      @pagy, @reservations = pagy(Reservation.not_archived.cancelled.includes(:route).order(:street_name, :house_number))
    elsif params[:missing]      
      @pagy, @reservations = pagy(Reservation.not_archived.missing.includes(:route).order(:street_name, :house_number))
    elsif params[:unconfirmed]      
      @pagy, @reservations = pagy(Reservation.not_archived.unconfirmed.includes(:route).order(:street_name, :house_number))
    elsif params[:all]
      @pagy, @reservations = pagy(Reservation.not_archived.includes(:route).order(:street_name, :house_number).order(created_at: :asc))
    elsif params[:archived]
      @pagy, @reservations = pagy(Reservation.archived.includes(:route).order(:street_name, :house_number).order(created_at: :asc))
    else
      @pagy, @reservations = pagy(Reservation.not_archived.pending_pickup.includes(:route).order(:street_name, :house_number))
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
    @reservation.cancelled!
    redirect_back(fallback_location: admin_root_path, notice: "Reservation was successfully cancelled.")
  end

  def map
    if params[:route_id]
      @reservations = Reservation.pending_pickup.where(route_id: params[:route_id]).geocoded.map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
    else
      @reservations = Reservation.pending_pickup.geocoded.map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
    end
  end

  def search
    @query = params[:search]
    if @query.downcase.include?('in:archive')
      query_without_param = @query.gsub('in:archive','').strip
      @pagy, @reservations = pagy(Reservation.archived.where("name ILIKE ? OR street ILIKE ?", "%" + Reservation.sanitize_sql_like(query_without_param) + "%", "%" + Reservation.sanitize_sql_like(query_without_param) + "%"))
    else
      @pagy, @reservations = pagy(Reservation.not_archived.where("name ILIKE ? OR street ILIKE ?", "%" + Reservation.sanitize_sql_like(@query) + "%", "%" + Reservation.sanitize_sql_like(@query) + "%"))
    end
    render :index
  end

  def process_route
    @reservation.route!
    @reservation.save
    redirect_back(fallback_location: admin_reservations_path)
  end

  def process_geocode
    @reservation.full_geocode!
    @reservation.save
    redirect_back(fallback_location: admin_reservations_path)
  end

  def process_all_routes
    Reservation.process_all_routes!
    redirect_to admin_reservations_path
  end

  def archive_all
    Reservation.archive_all!
    redirect_to admin_root_path, notice: 'All Reservations archived'
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :notes, :latitude, :longitude, :route_id, :status, :no_emails, :is_routed)
    end
end
