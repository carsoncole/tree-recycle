require "test_helper"

class DonationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = create(:reservation_with_coordinates, is_routed: false, no_emails: true)
    sleep 0.25
  end

  test "should get new, linked with reservation" do
    get new_reservation_donation_url(reservation_id: @reservation.id)
    assert_response :success
  end

  test "should get new, without a linked reservation" do
    get new_reservation_donation_url(@reservation)
    assert_response :success
  end

  test "should get no_donations" do
    post reservation_no_donation_path(@reservation)
    assert_redirected_to reservation_confirmed_url(@reservation)
  end

  test "donation without reservation" do
    get donation_without_reservation_url 
    assert_response :redirect
  end

  test "donation success without reservation" do
    get success_url
    assert_response :success
  end

  test "driver assisted donation success without reservation" do
    get success_url(driver: true)
    assert_response :success
  end
end
