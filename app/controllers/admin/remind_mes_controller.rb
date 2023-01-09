class Admin::RemindMesController < Admin::AdminController

  def index
    @pagy, @remind_mes = pagy(RemindMe.order(:name))
  end

  def destroy
    if current_user.editor? || current_user.administrator?
      @remind_me = RemindMe.find(params[:id])
      @remind_me.destroy
      redirect_to admin_remind_mes_path
    else
      redirect_to admin_remind_mes_path, alert: 'Unauthorized. Editor or Administrator access is required', status: :unauthorized
    end
  end

end
