class Admin::ReservationsController < Admin::AdminController
  before_action :set_reservation, except: %i[ new index search process_all_routes map archive_all_unarchived merge_unarchived destroy_all_archived destroy_unconfirmed destroy_all destroy_reservations upload]


  def index
    if params[:route_id]
      @pagy, @reservations = pagy(Reservation.not_archived.includes(:route).order(created_at: :desc).where(route_id: params[:route_id]))
    elsif params[:picked_up]
      @pagy, @reservations = pagy(Reservation.not_archived.picked_up.includes(:route).order(created_at: :desc))
    elsif params[:unrouted]
      @pagy, @reservations = pagy(Reservation.not_archived.unrouted.order(created_at: :desc))
    elsif params[:cancelled]
      @pagy, @reservations = pagy(Reservation.not_archived.cancelled.includes(:route).order(created_at: :desc))
    elsif params[:missing]      
      @pagy, @reservations = pagy(Reservation.not_archived.missing.includes(:route).order(created_at: :desc))
    elsif params[:unconfirmed]      
      @pagy, @reservations = pagy(Reservation.not_archived.unconfirmed.includes(:route).order(created_at: :desc))
    elsif params[:all]
      @pagy, @reservations = pagy(Reservation.not_archived.not_unconfirmed.includes(:route).order(created_at: :desc).order(created_at: :asc))
    elsif params[:archived]
      @pagy, @reservations = pagy(Reservation.archived.includes(:route).order(created_at: :desc).order(created_at: :asc))
    else
      @pagy, @reservations = pagy(Reservation.not_archived.not_unconfirmed.includes(:route).order(created_at: :desc))
    end
    @count_pending_pickups = Reservation.pending_pickup.count
    @count_not_routed = Reservation.not_archived.not_unconfirmed.unrouted.count
    @count_picked_up = Reservation.picked_up.count
    @count_missing = Reservation.missing.count
    @count_cancelled = Reservation.cancelled.count
    @count_archived = Reservation.archived.count
    @count_unconfirmed = Reservation.unconfirmed.count
  end

  def edit
  end

  def update
    if current_user.editor? || current_user.administrator?
      if @reservation.update(reservation_params)
        redirect_to admin_reservation_url(@reservation)
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to admin_reservation_url(@reservation), alert: 'Unauthorized. Editor or Adminstrator access is required.', status: :unauthorized
    end
  end

  def show
    @logs = @reservation.logs
    @statuses = Reservation.statuses.map {|key, value| key == "archived" ? nil : [key.titleize, key] }.compact
    @donations = @reservation.donations
  end

  def archive
    if current_user.editor? || current_user.administrator?
      @reservation.archived!
      redirect_back(fallback_location: admin_root_path, notice: "Reservation was successfully cancelled.")
    else
      redirect_to admin_reservation_url(@reservation), alert: 'Unauthorized. Editor or Adminstrator access is required.', status: :unauthorized
    end 
  end

  def destroy
    if current_user.administrator?
      @reservation.destroy
      redirect_to admin_reservations_path, notice: "Reservation was successfully destroyed."
    else
      redirect_to admin_reservation_url(@reservation), alert: 'Unauthorized. Adminstrator access is required.', status: :unauthorized
    end
  end

  def map
    if params[:route_id]
      @reservations = Reservation.pending_pickup.where(route_id: params[:route_id]).geocoded.map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
    else
      @reservations = Reservation.pending_pickup.geocoded.map{|r| [ r.latitude.to_s.to_f, r.longitude.to_s.to_f, 1]}
    end
  end

  def search
    @query = params[:search] || ""
    if @query.downcase.include?('in:archive')
      query_without_param = @query.gsub('in:archive','').strip
      @pagy, @reservations = pagy(Reservation.archived.where("name ILIKE ? OR street ILIKE ? OR email ILIKE ?", "%" + query_without_param + "%", "%" + query_without_param + "%", "%" + query_without_param + "%"))
    else
      @pagy, @reservations = pagy(Reservation.not_archived.where("name ILIKE ? OR street ILIKE ? OR email ILIKE ?", "%" + Reservation.sanitize_sql_like(params[:search]) + "%", "%" + Reservation.sanitize_sql_like(params[:search]) + "%", "%" + Reservation.sanitize_sql_like(params[:search]) + "%"))
    end
    render :index
  end

  def process_route
    if current_user.editor? || current_user.administrator?
      @reservation.route!
      @reservation.save
      redirect_back(fallback_location: admin_reservations_path)
    else
      redirect_to admin_reservation_url(@reservation), alert: 'Unauthorized. Editor or Adminstrator access is required.', status: :unauthorized
    end
  end

  def process_geocode
    if current_user.editor? || current_user.administrator?
      @reservation.full_geocode!
      @reservation.save
      redirect_back(fallback_location: admin_reservations_path)
    else
      redirect_to admin_reservation_url(@reservation), alert: 'Unauthorized. Editor or Adminstrator access is required.', status: :unauthorized
    end
  end

  def process_all_routes
    if current_user.editor? || current_user.administrator?
      Reservation.process_all_routes!
      redirect_to admin_reservations_path
    else
      redirect_to admin_reservations_path(pending_pickup: true), alert: 'Unauthorized. Editor or Adminstrator access is required.', status: :unauthorized
    end
  end

  def archive_all_unarchived
    if current_user.administrator?
      Reservation.archive_all_unarchived!
      redirect_to admin_settings_path, notice: 'All Reservations archived'
    else
      redirect_to admin_settings_path, alert: 'Unauthorized. Editor or Adminstrator access is required.', status: :unauthorized
    end
  end

  def merge_unarchived
    if current_user.administrator?
      Reservation.merge_unarchived_with_archived!
      redirect_to admin_settings_path, notice: 'Merging unarchived with archived was successful.'
    else
      redirect_to admin_settings_path, alert: 'Unauthorized. Editor or Adminstrator access is required.', status: :unauthorized
    end
  end

  def destroy_unconfirmed
    if current_user.administrator?
      Reservation.unconfirmed.destroy_all
      redirect_to admin_settings_path, notice: 'Destroying unconfirmed was successful.'
    else
      redirect_to admin_settings_path, alert: 'Unauthorized. Adminstrator access is required.', status: :unauthorized
    end
  end

  def destroy_reservations
    if current_user.administrator?
      Reservation.destroy_reservations_older_than_months(params[:months])
      redirect_to admin_settings_path, notice: "Destroying reservations older than #{params[:months]} months was successful."
    else
      redirect_to admin_settings_path, alert: 'Unauthorized. Adminstrator access is required.', status: :unauthorized
    end    
  end


  def destroy_all
    if current_user.administrator?
      Reservation.destroy_all
      redirect_to admin_settings_path, notice: 'All Reservations destroyed'
    else
      redirect_to admin_settings_path, alert: 'Unauthorized. Adminstrator access is required.', status: :unauthorized
    end
  end

  def destroy_all_archived
    if current_user.administrator?
      Reservation.destroy_all_archived!
      redirect_to admin_root_path, notice: 'All archived Reservations destroyed'
    else
      redirect_to admin_settings_path, alert: 'Unauthorized. Adminstrator access is required.', status: :unauthorized
    end
  end

  def upload
    Reservation.import(params[:file])
    redirect_to reservations_path #=> or where you want
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :notes, :latitude, :longitude, :route_id, :status, :no_emails, :no_sms, :is_routed, :unit, :is_geocoded)
    end
end
