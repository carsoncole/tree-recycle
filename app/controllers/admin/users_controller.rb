class Admin::UsersController < Clearance::UsersController
  before_action :require_login
  before_action :require_administrator

  def index
    @users = User.all
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :phone)
    end

    def require_administrator
      redirect_to sign_in_path unless current_user.administrator?
    end
end