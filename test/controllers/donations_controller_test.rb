require "test_helper"

class DonationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = create(:reservation_with_coordinates)
  end

  test "should get new" do
    get new_reservation_donation_url(reservation_id: @reservation.id)
    assert_response :success
  end

  # test "should create donation" do
  #   assert_difference("Donation.count") do
  #     post donations_url, params: { donation: { new: @donation.new } }
  #   end

  #   assert_redirected_to donation_url(Donation.last)
  # end
end
