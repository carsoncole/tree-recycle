require "test_helper"

class Admin::DonationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @donation = create :donation
    @viewer = create :viewer
  end

  test "should get index" do
    get admin_donations_url(as: @viewer)
    assert_response :success
  end

  test "should get show" do
    get admin_donation_url(@donation, as: @viewer)
    assert_response :success
  end
end
