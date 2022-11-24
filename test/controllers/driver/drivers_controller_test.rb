require "test_helper"

class Driver::DriversControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get driver_drivers_url
    assert_response :success
  end

  test "should show driver" do
    @driver = create(:driver)
    get driver_driver_url(@driver)
    assert_response :success
  end

end
