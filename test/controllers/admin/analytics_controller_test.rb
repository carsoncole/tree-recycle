require "test_helper"

class Admin::AnalyticsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @viewer = create(:viewer)
  end

  test "should get index" do
    get admin_analytics_url(as: @viewer)
    assert_response :success
  end

  test "should not get index" do
    get admin_analytics_url
    assert_redirected_to sign_in_path
  end
end
