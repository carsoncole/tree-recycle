require "test_helper"

class Admin::DonationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @donation = create :donation
    @viewer = create :viewer
    @editor = create :editor
  end

  test "should get index" do
    get admin_donations_url(as: @viewer)
    assert_response :success
  end

  test "should get show" do
    get admin_donation_url(@donation, as: @viewer)
    assert_response :success
  end

  test "should get new" do
    get new_admin_donation_url(as: @viewer)
    assert_response :success
  end

  test "should create" do
    assert_difference('Donation.count', 1) do 
      post admin_donations_url(as: @editor), params: { donation: attributes_for(:donation) }
    end
    assert_redirected_to admin_donations_url
  end

  test "should not create as viewer" do
    assert_difference('Donation.count', 0) do 
      post admin_donations_url(as: @viewer), params: { donation: attributes_for(:donation) }
    end
    assert_response :unauthorized
  end

  test "should create reservation linked" do
    assert_difference('Donation.count', 1) do 
      post admin_donations_url(as: @editor), params: { donation: attributes_for(:reservation_donation) }
    end
    assert_redirected_to admin_donations_url
  end
end
