# Preview all emails at http://localhost:3000/rails/mailers/
class MarketingMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

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
