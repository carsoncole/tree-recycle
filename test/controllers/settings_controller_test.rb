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

  # test "should get new" do
  #   get new_setting_url
  #   assert_response :success
  # end

  # test "should create setting" do
  #   assert_difference("Setting.count") do
  #     post settings_url, params: { setting: { contact_email: @setting.contact_email, contact_name: @setting.contact_name, contact_phone: @setting.contact_phone, description: @setting.description, organization_name: @setting.organization_name, pickup_date: @setting.pickup_date } }
  #   end

  #   assert_redirected_to setting_url(Setting.last)
  # end

  # test "should show setting" do
  #   get setting_url(@setting)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_setting_url(@setting)
  #   assert_response :success
  # end

  # test "should update setting" do
  #   patch setting_url(@setting), params: { setting: { contact_email: @setting.contact_email, contact_name: @setting.contact_name, contact_phone: @setting.contact_phone, description: @setting.description, organization_name: @setting.organization_name, pickup_date: @setting.pickup_date } }
  #   assert_redirected_to setting_url(@setting)
  # end

  # test "should destroy setting" do
  #   assert_difference("Setting.count", -1) do
  #     delete setting_url(@setting)
  #   end

  #   assert_redirected_to settings_url
  # end
end
