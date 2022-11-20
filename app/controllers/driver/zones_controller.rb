class Driver::ZonesController < Driver::DriverController
  def index
    @zones = Zone.includes(:routes).all.order(:name)
    @pending_pickups_count = Reservation.pending_pickup.routed.count
    @missing_count = Reservation.missing.count
    @picked_up_count = Reservation.picked_up.count
  end
end
