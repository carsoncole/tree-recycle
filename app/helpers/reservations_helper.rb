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
      elsif reservation.archived?
        ['Archived', 'info']
      end
    if status
      out = ''
      out << "<div class='reservation-status-badge #{status[1]}'>#{status[0]}</div>"
      out.html_safe
    end
  end

  def donation_status(reservation)
    return unless reservation.persisted?
    status = if reservation.stripe_charge_amount.present?
        ['Stripe Donated', 'info']
      elsif reservation.is_cash_or_check?
        ['Cash or Check', 'danger']
      end
    if status
      out = ''
      out << "<div class='donation-status-badge #{status[1]}'>#{status[0]}</div>"
      out.html_safe
    end
  end
end
