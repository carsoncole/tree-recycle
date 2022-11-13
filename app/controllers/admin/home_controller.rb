class Admin::HomeController < Admin::AdminController
  def index
  end

  def archive_all
    Reservation.archive_all!
    redirect_to admin_root_path, notice: 'All Reservations archived'
  end
end
