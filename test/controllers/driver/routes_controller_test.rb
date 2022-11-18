require "test_helper"

class Driver::RoutesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    route = create(:route)
    get driver_route_url(route)
    assert_response :success
  end

  test "should get show with auth" do
    setting = create(:setting_with_driver_auth)
    route = create(:route)

    get driver_route_url(route)
    assert_redirected_to sign_in_path

    get driver_route_url(route, key: setting.driver_secret_key)
    assert_response :success
    assert_select "h1", text: route.name_with_zone
  end
end
