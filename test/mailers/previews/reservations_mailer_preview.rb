# Preview all emails at http://localhost:3000/rails/mailers/reservations_mailer
class ReservationsMailerPreview < ActionMailer::Preview

  def confirmed_reservation_email
    Reservation.first.update(is_confirmed_reservation_email_sent: false)
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).confirmed_reservation_email
  end

  def pick_up_reminder_email
    Reservation.first.update(is_pick_up_reminder_email_sent: false)
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).pick_up_reminder_email
  end

  def hello_email
    Reservation.first.update(is_hello_email_sent: false)
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).hello_email
  end

  def last_call_email
    Reservation.first.update(is_last_call_email_sent: false)
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).last_call_email
  end

  def cancelled_reservation_email
    # Reservation.first.update(is_last_call_email_sent: false)
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).cancelled_reservation_email
  end
end
