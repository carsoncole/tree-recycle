class Admin::SettingsController < Admin::AdminController

  def index
    @setting = helpers.setting
  end

  def edit
  end

  def update
    if helpers.setting.update(setting_params)
      if setting_params[ :is_emailing_enabled ]
        redirect_to admin_root_path
      else
        redirect_to admin_settings_url
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def setting_params
      params.require(:setting).permit(:site_title, :site_description, :organization_name, :contact_name, :contact_email, :contact_phone, :description, :pickup_date_and_time, :pickup_date_and_end_time, :is_reservations_open, :is_reservations_editable, :is_emailing_enabled, :default_city, :default_state, :default_country, :sign_up_deadline_at, :on_day_of_pickup_instructions)
    end
end
