# Preview all emails at http://localhost:3000/rails/mailers/
class MarketingMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def remind_me_we_are_now_live_email
    # @reservation = Reservation.find '519f2389-c218-49d6-9b20-2cebd37514a8'
    @reservation = create(:remind_me)
    MarketingMailer.with(reservation: @reservation).remind_me_we_are_live_email
  end

  def marketing_email_1
    # @reservation = Reservation.find '519f2389-c218-49d6-9b20-2cebd37514a8'
    @reservation = create(:reservation_with_coordinates, status: :archived)
    MarketingMailer.with(reservation: @reservation).marketing_email_1
  end

  def marketing_email_2
    @reservation = create(:reservation_with_coordinates, status: :archived)
    MarketingMailer.with(reservation: @reservation).marketing_email_2
  end
end
