class Admin::UsersController < Clearance::UsersController
  before_action :require_login
  before_action :require_administrator
  layout 'admin/admin'

  def index
    @users = User.order(:email)
    @roles = User.roles.map {|key, value| [key.titleize, key] }.compact
  end


  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_url, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :phone, :role)
    end

    def require_administrator
      redirect_to sign_in_path unless current_user.administrator?
    end
end