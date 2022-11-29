class Admin::DonationsController < Admin::AdminController
  def index
    @donations = Donation.order(id: :desc)
  end

  def show
    @donation = Donation.find(params[:id])
  end
end
