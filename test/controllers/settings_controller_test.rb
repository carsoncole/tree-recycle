require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "should get index with auth" do
    get admin_settings_url(as: @user)
    assert_response :success
  end

  test "should not get index with auth" do
    get admin_settings_url
    assert_redirected_to sign_in_path
  end

  # test "should create setting" do
  #   assert_difference("Setting.count") do
  #     post settings_url, params: { setting: { contact_email: @setting.contact_email, contact_name: @setting.contact_name, contact_phone: @setting.contact_phone, description: @setting.description, organization_name: @setting.organization_name, pickup_date: @setting.pickup_date } }
  #   end

  #   assert_redirected_to setting_url(Setting.last)
  # end

  test "should get edit" do
    @setting = create(:setting)
    get edit_admin_setting_url(@setting, as: @user)
    assert_response :success
  end

  test "should update setting" do
    @setting = create(:setting)
    patch admin_setting_url @setting, as: @user, params: { setting: { contact_email: 'test@example.com', contact_name: @setting.contact_name, contact_phone: @setting.contact_phone, description: @setting.description, organization_name: @setting.organization_name, pickup_date: @setting.pickup_date } }
    assert_redirected_to admin_settings_url
  end

end
