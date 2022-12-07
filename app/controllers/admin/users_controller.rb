class Admin::UsersController < Clearance::UsersController
  before_action :require_login
  skip_before_action :redirect_signed_in_users, only: :create
  layout 'admin/admin'

  def index
    @users = User.order(:email)
    @roles = User.roles.map {|key, value| [key.titleize, key] }.compact
    @user = User.new
  end

  def update
    @user = User.find(params[:id])

    if current_user.administrator?
      if @user.update(user_params)
        redirect_to admin_users_url, notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to admin_users_path, status: :unauthorized
    end
  end

  def create
    if current_user.administrator?
      @user = User.new(user_params)  
      if @user.save
        redirect_to admin_users_url, notice: "User was successfully created."
      else
        @users = User.order(:email)
        @roles = User.roles.map {|key, value| [key.titleize, key] }.compact
        render :index, status: :unprocessable_entity
      end

    else
      redirect_to admin_users_path, status: :unauthorized
    end   
  end

  def destroy
    if current_user.administrator?
      @user = User.find(params[:id]) 
      @user.destroy
      redirect_to admin_users_url, notice: "User was successfully destrotyed."
    else
      redirect_to admin_users_path, status: :unauthorized
    end   
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :phone, :role)
    end

end