module ReservationsHelper
  def reservation_status(reservation)
    status = if reservation.is_picked_up
        ['Picked Up', 'info']
      elsif reservation.is_cancelled
        ['Cancelled', 'danger']
      elsif reservation.is_missing
        ['Missing', 'warning']
      else
        ['Pending', 'primary']
      end
    out = ''
    out << "<div class='reservation-status-badge #{status[1]}'>#{status[0]}</div>"
    out.html_safe
  end
end
