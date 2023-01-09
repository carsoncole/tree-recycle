class Admin::SettingsController < Admin::AdminController

  def index
    @setting = helpers.setting
  end

  def edit
  end

  def update
    if current_user.editor? || current_user.administrator?
      if helpers.setting.update(setting_params)
        redirect_to admin_settings_path
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to admin_settings_path, notice: 'Unauthorized. Editor or Administrator access is required. ', status: :unauthorized
    end
  end

  private
    def setting_params
      params.require(:setting).permit(:site_description, :contact_name, :contact_email, :contact_phone, :description, :is_reservations_open, :is_reservations_editable, :is_emailing_enabled, :on_day_of_pickup_instructions, :driver_secret_key, :meta_site_name, :meta_title, :meta_description, :meta_image_filename, :facebook_page_id, :reservations_closed_message, :is_driver_site_enabled, :email_batch_quantity, :driver_instructions)
    end
end
