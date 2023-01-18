class Admin::OperationsController < Admin::AdminController
  def index
    @archived_reservations_count = Reservation.archived.count
    @reservations_count = Reservation.count
    @unconfirmed_reservations_count = Reservation.unconfirmed.count
  end

  def update
  end
end
