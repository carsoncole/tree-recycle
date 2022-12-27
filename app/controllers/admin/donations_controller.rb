class Admin::DonationsController < Admin::AdminController
  def index
    @pagy, @donations = pagy(Donation.order(id: :desc))
  end

  def show
    @donation = Donation.find(params[:id])
  end

  def send_donation_receipt
    donation = Donation.find(params[:donation_id])
    donation.send_receipt_email!
    redirect_to admin_reservation_url(donation.reservation)
  end
end
