class Admin::DonationsController < Admin::AdminController
  def index
    @donations = Donation.all
  end

  def show
    @donation = Donation.find(params[:id])
  end
end
