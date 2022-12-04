class Admin::MarketingController < Admin::AdminController
  def index
    @sources = Reservation.heard_about_sources
  end
end
