class Admin::SettingsController < ApplicationController
  before_action :require_login
  before_action :set_setting, only: %i[ show edit update destroy ]

  # GET /settings or /settings.json
  def index
    @setting = Setting.first_or_create
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings or /settings.json
  def create
    @setting = Setting.new(setting_params)

    if @setting.save
      redirect_to admin_settings_url, notice: "Setting was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /settings/1 or /settings/1.json
  def update
    if @setting.update(setting_params)
      redirect_to admin_settings_url, notice: "Setting was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /settings/1 or /settings/1.json
  def destroy
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to admin_settings_url, notice: "Setting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first_or_create
    end

    # Only allow a list of trusted parameters through.
    def setting_params
      params.require(:setting).permit(:site_title, :site_description, :organization_name, :contact_name, :contact_email, :contact_phone, :description, :pickup_date)
    end
end
