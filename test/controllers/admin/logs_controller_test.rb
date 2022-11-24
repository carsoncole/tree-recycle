require "test_helper"

class Admin::LogsControllerTest < ActionDispatch::IntegrationTest
  
  test "logs index for turbo" do 
    reservation = create(:reservation_with_coordinates, is_routed: false)

    get admin_reservation_logs_path(reservation, as: create(:user))
    assert_response :success
  end

end