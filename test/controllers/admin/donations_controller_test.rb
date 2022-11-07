require "test_helper"

class Admin::DonationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @donation = create :donation
    @user = create :user
  end

  test "should get index" do
    get admin_donations_url(as: @user)
    assert_response :success
  end

  test "should get show" do
    get admin_donation_url(@donation, as: @user)
    assert_response :success
  end
end
