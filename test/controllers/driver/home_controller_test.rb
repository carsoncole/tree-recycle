require "test_helper"

class Driver::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get driver_home_url
    assert_response :success
    assert_select "h1", "Welcome Drivers!"
  end
end
