class Admin::UsersController < Clearance::UsersController
  before_action :require_login
  skip_before_action :redirect_signed_in_users, only: :create
  layout 'admin/admin'

  def index
    @users = User.order(:email)
    @roles = User.roles.map {|key, value| [key.titleize, key] }.compact
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    @roles = User.roles.map {|key, value| [key.titleize, key] }.compact
  end

  def update
    @user = User.find(params[:id])
    role_id = User.roles[@user.role]
    new_role_id = User.roles[user_params[:role]]
    if current_user.role_rank >= role_id && current_user.role_rank >= new_role_id
      if @user.update(user_params)
        redirect_to admin_users_url, notice: "User was successfully updated."
      else
        @roles = User.roles.map {|key, value| [key.titleize, key] }.compact
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to admin_users_url, notice: "Not authorized. You can edit users with the same role as your #{current_user.role.capitalize } role or less."
    end
  end

  def create
    role_id = User.roles[params[:user][:role]]
    if current_user.role_rank >= role_id
      @user = User.new(user_params)  
      if @user.save
        redirect_to admin_users_url, notice: "User was successfully created."
      else
        @users = User.order(:email)
        @roles = User.roles.map {|key, value| [key.titleize, key] }.compact
        render :index, status: :unprocessable_entity
      end
    else
      redirect_to admin_users_url, notice: "Not authorized. You can create users with the same role as your #{current_user.role.capitalize } role or less."
    end   
  end

  def destroy
    @user = User.find(params[:id]) 
    role_id = User.roles[@user.role]
    if current_user.role_rank >= role_id
      if current_user == @user
        redirect_to admin_users_url, notice: "You can't delete your own user account"
      else
        @user = User.find(params[:id]) 
        @user.destroy
        redirect_to admin_users_url, notice: "User was successfully destroyed."
      end
    else
      redirect_to admin_users_path, status: :unauthorized, notice: "Not authorized. You can delete users with the same role as your #{current_user.role.capitalize } role or less."
    end   
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :phone, :role)
    end

end