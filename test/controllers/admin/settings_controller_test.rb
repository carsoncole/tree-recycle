require "test_helper"

class Admin::SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @viewer = create(:viewer)
    @editor = create(:editor)
    @administrator = create(:administrator)
  end

  test "should get index with auth" do
    get admin_settings_url(as: @viewer)
    assert_response :success
  end

  test "should not get index without auth" do
    get admin_settings_url
    assert_redirected_to sign_in_path
  end

  test "should get edit" do
    get edit_admin_setting_url(setting, as: @viewer)
    assert_response :success
  end

  test "should not update setting as viewer" do
    patch admin_setting_url setting, as: @viewer, params: { setting: { contact_email: 'test@example.com', contact_name: setting.contact_name, contact_phone: setting.contact_phone, description: setting.description, oringganization_name: setting.organization_name, pickup_date_and_time: setting.pickup_date_and_time } }
    assert_response :unauthorized
  end

  test "should update setting as editor" do
    patch admin_setting_url setting, as: @editor, params: { setting: { contact_email: 'test@example.com', contact_name: setting.contact_name, contact_phone: setting.contact_phone, description: setting.description, oringganization_name: setting.organization_name, pickup_date_and_time: setting.pickup_date_and_time } }
    assert_redirected_to admin_settings_url
  end

  test "should update setting as administrator" do
    patch admin_setting_url setting, as: @administrator, params: { setting: { contact_email: 'test@example.com', contact_name: setting.contact_name, contact_phone: setting.contact_phone, description: setting.description, oringganization_name: setting.organization_name, pickup_date_and_time: setting.pickup_date_and_time } }
    assert_redirected_to admin_settings_url
  end

end
