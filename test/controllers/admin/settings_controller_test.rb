require "test_helper"

class Admin::SettingsControllerTest < ActionDispatch::IntegrationTest
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

  test "should get edit" do
    get edit_admin_setting_url(setting, as: @user)
    assert_response :success
  end

  test "should update setting" do
    patch admin_setting_url setting, as: @user, params: { setting: { contact_email: 'test@example.com', contact_name: setting.contact_name, contact_phone: setting.contact_phone, description: setting.description, oringganization_name: setting.organization_name, pickup_date_and_time: setting.pickup_date_and_time } }
    assert_redirected_to admin_settings_url
  end

end
