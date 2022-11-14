class Admin::HomeController < Admin::AdminController
  def index
    @pending_pickups_count = Reservation.pending_pickup.count
    @picked_up_count = Reservation.picked_up.count
    @routed_pickups_count = Reservation.not_archived.routed.count
    @un_routed_pickups_count = Reservation.not_archived.unrouted.count
    @archived_count = Reservation.archived.count
    @not_archived_count = Reservation.not_archived.count
  end

  def archive_all
    Reservation.archive_all!
    redirect_to admin_root_path, notice: 'All Reservations archived'
  end
end
