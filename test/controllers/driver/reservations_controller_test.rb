require "test_helper"

class Driver::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get map" do
    route = create(:route)
    get driver_reservations_map_url(route_id: route.id)
    assert_response :success
  end

  test "should get search" do
    get driver_reservations_search_url
    assert_response :success
  end
end
