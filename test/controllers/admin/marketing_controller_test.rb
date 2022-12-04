require "test_helper"

class Admin::MarketingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @viewer = create :viewer
  end

  test "should get index" do
    get admin_marketing_url(as: @viewer)
    assert_response :success
  end
end
