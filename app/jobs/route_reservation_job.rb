class RouteReservationJob < ApplicationJob
  queue_as :low_priority

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)
    return unless reservation.is_routed? && reservation.geocoded?
    reservation.route!
  end
end
