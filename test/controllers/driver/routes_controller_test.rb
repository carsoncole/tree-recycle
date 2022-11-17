require "test_helper"

class Driver::RoutesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get driver_routing_url
    assert_response :success
    assert_select "h1", "Routes"
  end

  test "should get show" do
    route = create(:route)
    get driver_route_url(route)
    assert_response :success
  end
end
