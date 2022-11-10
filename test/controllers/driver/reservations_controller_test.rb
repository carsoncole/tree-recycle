require "test_helper"

class Driver::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get map" do
    zone = create(:zone)
    get driver_reservations_map_url(zone_id: zone.id)
    assert_response :success
    assert_text zone.name
  end

  test "should get search" do
    get driver_reservations_search_url
    assert_response :success
  end
end
