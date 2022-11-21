require "test_helper"

class Driver::ContactControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get driver_contacts_url
    assert_response :success
  end
end
