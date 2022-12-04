require "test_helper"

class Driver::RoutesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    route = create(:route_with_coordinates, is_zoned: false)
    get driver_route_url(route)
    assert_response :success
  end

  test "should get show with auth" do
    setting_generate_driver_secret_key!
    route = create(:route_with_coordinates, is_zoned: false)
    sleep 0.25

    get driver_route_url(route)
    assert_redirected_to sign_in_path

    get driver_route_url(route, key: setting.driver_secret_key)
    assert_response :success
    assert_select "h1", text: route.name_with_zone
  end
end
