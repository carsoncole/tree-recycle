# Preview all emails at http://localhost:3000/rails/mailers/
class ReservationsMailerPreview < ActionMailer::Preview

  def confirmed_reservation_email
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).confirmed_reservation_email
  end

  def pick_up_reminder_email
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).pick_up_reminder_email
  end

  def hello_email
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).hello_email
  end

  def last_call_email
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).last_call_email
  end

  def cancelled_reservation_email
    reservation = Reservation.first
    ReservationsMailer.with(reservation: reservation).cancelled_reservation_email
  end
end
