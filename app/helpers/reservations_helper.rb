module ReservationsHelper
  def reservation_status(reservation)
    return unless reservation.persisted?
    status = if reservation.picked_up?
        ['Picked Up', 'info']
      elsif reservation.cancelled?
        ['Cancelled', 'danger']
      elsif reservation.missing?
        ['Missing', 'warning']
      elsif reservation.pending_pickup?
        ['Pending pickup', 'primary']
      else
        ['No status', 'danger']
      end
    out = ''
    out << "<div class='reservation-status-badge #{status[1]}'>#{status[0]}</div>"
    out.html_safe
  end
end
