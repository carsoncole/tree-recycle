class Admin::LogsController < Admin::AdminController

  def reservation_index
    @reservation = Reservation.find(params[:reservation_id])
    @logs = @reservation.logs.order(created_at: :desc)
  end

  def index
    @pagy, @logs = pagy(Log.order(created_at: :desc))
  end

  def destroy
    Log.delete_all
    redirect_to admin_logs_path, notice: 'All logs destoyed.'
  end

end
