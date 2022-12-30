class Admin::LogsController < Admin::AdminController

  def reservation_index
    @reservation = Reservation.find(params[:reservation_id])
    @logs = @reservation.logs.order(created_at: :desc)
  end

  def index
    @logs = Log.order(created_at: :desc).limit(20)
  end

end
