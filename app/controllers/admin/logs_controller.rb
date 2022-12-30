class Admin::LogsController < Admin::AdminController

  def index
    @reservation = Reservation.find(params[:reservation_id])
    @logs = @reservation.logs.order(created_at: :desc)
  end

  def all
    @logs = Log.order(created_at: :desc)
  end

end
