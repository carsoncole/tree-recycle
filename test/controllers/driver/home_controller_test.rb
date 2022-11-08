require "test_helper"

class Driver::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get driver_home_index_url
    assert_response :success
  end
end
