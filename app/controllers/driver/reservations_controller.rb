class Driver::ReservationsController < Driver::DriverController
  def show
    @reservation = Reservation.not_archived.find(params[:id])
  end

  def search
    if params[:search]
      @query = params[:search]
      @pagy, @reservations = pagy(Reservation.not_archived.where("name ILIKE ? OR street ILIKE ? OR email ILIKE ?", "%" + Reservation.sanitize_sql_like(params[:search]) + "%", "%" + Reservation.sanitize_sql_like(params[:search]) + "%", "%" + Reservation.sanitize_sql_like(params[:search]) + "%"))
    end
  end

  def map
    flash[:notice] = "Reservation status changes are NOT enabled." unless helpers.setting.is_driver_site_enabled?
    if params[:route_id]
      @route = Route.find(params[:route_id])
      @reservations = Reservation.pending.where(route: @route ).geocoded.map{ |r| [ r.id.to_s, r.street.to_s, r.latitude.to_s.to_f, r.longitude.to_s.to_f, r.notes || "", r.status.humanize.capitalize, r.phone || "", r.donation || "", r.collected || "", r.collected_amount || ""] }
    elsif params[:zone_id]
      @zone = Zone.find(params[:zone_id])
      @reservations = @zone.reservations.pending_pickup.geocoded.map{ |r| [ r.id.to_s, r.street.to_s, r.latitude.to_s.to_f, r.longitude.to_s.to_f, r.notes || "", r.status.humanize.capitalize, r.phone || "", r.donation || "", r.collected || "", r.collected_amount || ""] }
    elsif params[:reservation_id]
      @reservation = Reservation.find(params[:reservation_id])
      @reservations = [ @reservation.id.to_s, @reservation.street.to_s, @reservation.latitude.to_s.to_f, @reservation.longitude.to_s.to_f, @reservation.notes || "", @reservation.status.humanize.capitalize, @reservation.phone || "", @reservation.donation || "", @reservation.collected || "", @reservation.collected_amount || ""]
    else
      @reservations = Reservation.pending_pickup.geocoded.map{ |r| [ r.id.to_s, r.street.to_s, r.latitude.to_s.to_f, r.longitude.to_s.to_f, r.notes || "", r.status.humanize.capitalize, r.phone || "", r.donation || "", r.collected || "", r.collected_amount || ""] }
    end
  end

  def update
    @reservation = Reservation.find(params[:id])
    if helpers.setting.is_driver_site_enabled?
      if params[:status]
        case params[:status]
        when  'picked_up'
          @reservation.picked_up!
        when 'missing'
          @reservation.missing!
        when 'pending_pickup'
          @reservation.pending_pickup!
        end
      else
        @reservation.collected = 'cash' if params[:collected] == 'cash'
        @reservation.collected = 'check' if params[:collected] == 'check'
        @reservation.collected = 'door_hanger' if params[:collected] == 'door_hanger'
        @reservation.collected_amount = params[:collected_amount] if params[:collected_amount].present?
        @reservation.save
      end
      if params[:view]=='map'
        redirect_to driver_reservations_map_path(route_id: @reservation.route_id)
      else 
        redirect_to driver_route_path(@reservation.route)
      end
    else
      redirect_to driver_route_path(@reservation.route), status: 405
    end
  end
end
