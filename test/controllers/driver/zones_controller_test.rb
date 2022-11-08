require "test_helper"

class Driver::ZonesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get driver_zones_index_url
    assert_response :success
  end
end
