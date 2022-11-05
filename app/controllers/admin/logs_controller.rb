class Admin::LogsController < Admin::AdminController

  def index
    @reservation = Reservation.find(params[:reservation_id])
    @logs = @reservation.logs
  end

end
