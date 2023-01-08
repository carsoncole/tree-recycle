# Preview all emails at http://localhost:3000/rails/mailers/
class ReservationsMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def confirmed_reservation_email
    @reservation = create(:reservation_with_coordinates)
    ReservationsMailer.with(reservation: @reservation).confirmed_reservation_email
  end

  def pick_up_reminder_email
    @reservation = create(:reservation_with_coordinates)
    ReservationsMailer.with(reservation: @reservation).pick_up_reminder_email
  end

  def pick_up_reminder_email_with_donation
    @reservation = create(:reservation_with_coordinates, no_emails: true)
    @reservation.donations.create(amount: 25)
    ReservationsMailer.with(reservation: @reservation).pick_up_reminder_email
  end

  def cancelled_reservation_email
    @reservation = create(:reservation_with_coordinates)
    ReservationsMailer.with(reservation: @reservation).cancelled_reservation_email
  end

  def missing_tree_email
    @reservation = create(:reservation_with_coordinates, notes: 'tree will be next to the mailboxes at the end of the street')
    ReservationsMailer.with(reservation: @reservation).missing_tree_email
  end
end
