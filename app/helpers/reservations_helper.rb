module ReservationsHelper
  def reservation_info_status(reservation)
    return unless reservation.persisted?
    status = if reservation.picked_up?
        ['Your tree has been picked up.', 'info']
      elsif reservation.cancelled?
        ['Your tree pickup reservation has been Cancelled.', 'danger']
      elsif reservation.missing?
        ['Your tree could not be found.', 'warning']
      elsif reservation.pending_pickup?
        ['This reservation is scheduled for pickup.', 'primary']
      elsif reservation.archived?
        ['Archived', 'info']
      elsif reservation.unconfirmed?
        ['Unconfirmed. Not scheduled for pickup.', 'warning']
      end
    if status
      out = ''
      out << "<div class='important-message #{status[1]}'>#{status[0]}</div>"
      out.html_safe
    end
  end

  def reservation_status(reservation)
    return unless reservation.persisted?
    status = if reservation.picked_up?
        ['Picked Up', 'info']
      elsif reservation.cancelled?
        ['Cancelled', 'danger']
      elsif reservation.missing?
        ['Missing', 'warning']
      elsif reservation.pending_pickup?
        ['Pending Pickup', 'primary']
      elsif reservation.archived?
        ['Archived', 'info']
      elsif reservation.unconfirmed?
        ['Unconfirmed', 'warning']
      end
    if status
      out = ''
      out << "<div class='status #{status[1]}'>#{status[0]}</div>"
      out.html_safe
    end
  end


  def donation_status(reservation)
    return unless reservation.persisted?
    status = if reservation.online_donation?
        ['Stripe Donated', 'info']
      elsif reservation.cash_or_check_donation?
        ['Cash or Check', 'danger']
      elseif reservation.no_donation?
        ['No Donation', 'info']
      else
        ['Nothing selected', 'info']
      end
    if status
      out = ''
      out << "<div class='#{status[1]}'>#{status[0]}</div>"
      out.html_safe
    end
  end

  def reservation_zone_route(reservation)
    (reservation&.zone&.name || 'No Zone') + ' / ' + (reservation&.route&.name || 'No Route')
  end
end
