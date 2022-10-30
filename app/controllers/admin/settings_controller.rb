class Admin::SettingsController < Admin::AdminController
  before_action :set_setting, only: %i[ edit update ]

  # GET /settings or /settings.json
  def index
    @setting = Setting.first_or_create
  end

  # GET /settings/1/edit
  def edit
  end

  # PATCH/PUT /settings/1 or /settings/1.json
  def update
    if @setting.update(setting_params)
      redirect_to admin_settings_url, notice: "Setting was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first_or_create
    end

    # Only allow a list of trusted parameters through.
    def setting_params
      params.require(:setting).permit(:site_title, :site_description, :organization_name, :contact_name, :contact_email, :contact_phone, :description, :pickup_date_and_time, :is_reservations_open, :is_reservations_editable, :is_emailing_enabled)
    end
end
