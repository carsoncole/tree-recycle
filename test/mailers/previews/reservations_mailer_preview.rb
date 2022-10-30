# Preview all emails at http://localhost:3000/rails/mailers/reservations_mailer
class ReservationsMailerPreview < ActionMailer::Preview
  def confirmed_reservation_email
    ReservationsMailer.with(reservation: Reservation.first).confirmed_reservation_email
  end

  def pick_up_reminder_email
    ReservationsMailer.with(reservation: Reservation.first).pick_up_reminder_email
  end
end
