class Admin::SettingsController < Admin::AdminController

  def index
    @setting = helpers.setting
  end

  def edit
  end

  def update
    if current_user.editor? || current_user.administrator?
      if helpers.setting.update(setting_params)
        if params[:source] && params[:source] == 'marketing'
          redirect_to admin_marketing_path, notice: 'Settings updated.'
        else
          redirect_to admin_settings_path
        end
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to admin_settings_path, notice: 'Unauthorized. Editor or Administrator access is required. ', status: :unauthorized
    end
  end

  private
    def setting_params
      params.require(:setting).permit(:site_title, :site_description, :organization_name, :contact_name, :contact_email, :contact_phone, :description, :pickup_date_and_time, :pickup_date_and_end_time, :is_reservations_open, :is_reservations_editable, :is_emailing_enabled, :default_city, :default_state, :default_country, :sign_up_deadline_at, :on_day_of_pickup_instructions, :driver_secret_key, :meta_site_name, :meta_title, :meta_description, :meta_image_filename, :facebook_page_id, :reservations_closed_message, :is_driver_site_enabled, :email_batch_quantity, :donation_notification_sms_number)
    end
end
