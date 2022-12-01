class Admin::DonationsController < Admin::AdminController
  def index
    @pagy, @donations = pagy(Donation.order(id: :desc))
  end

  def show
    @donation = Donation.find(params[:id])
  end
end
