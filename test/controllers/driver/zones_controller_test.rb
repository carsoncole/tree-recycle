require "test_helper"

class Driver::ZonesControllerTest < ActionDispatch::IntegrationTest
  test "should get driver root/routing" do
    get driver_routing_url
    assert_response :success
    assert_select "h1", "Routes"

    get driver_root_url
    assert_response :success
    assert_select "h1", "Routes"
  end

  test "should get driver root and routing" do
    setting_generate_driver_secret_key!

    get driver_routing_url
    assert_redirected_to sign_in_path

    get driver_routing_url(key: setting.driver_secret_key)
    assert_response :success
    assert_select "h1", "Routes"
  end

end
