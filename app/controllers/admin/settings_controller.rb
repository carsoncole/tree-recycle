class Admin::SettingsController < Admin::AdminController

  def index
    @setting = helpers.setting
  end

  def edit
  end

  def update
    if helpers.setting.update(setting_params)
      if setting_params[ :is_emailing_enabled ] || setting_params[ :is_reservations_open ]
        redirect_to admin_settings_path
      else
        redirect_to admin_settings_url
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def setting_params
      params.require(:setting).permit(:site_title, :site_description, :organization_name, :contact_name, :contact_email, :contact_phone, :description, :pickup_date_and_time, :pickup_date_and_end_time, :is_reservations_open, :is_reservations_editable, :is_emailing_enabled, :default_city, :default_state, :default_country, :sign_up_deadline_at, :on_day_of_pickup_instructions, :driver_secret_key, :sms_from_phone)
    end
end
