require "test_helper"

class Driver::ZonesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get driver_zones_url
    assert_response :success
    assert_select "h1", "Zones"
  end

  test "should get show" do
    zone = create(:zone)
    get driver_zones_url(zone)
    assert_response :success
  end
end
