require "test_helper"

class DonationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = create(:reservation_with_coordinates, is_routed: false, no_emails: true)
  end

  # donation main page
  test "should get new, with a linked reservation" do
    get new_reservation_donation_url(@reservation)
    assert_response :success
  end

  # donation choice #1
  test "online donation" do 
    post reservation_donations_path(@reservation)
    assert_response :redirect
  end

  # donation choice #2
  test "cash or check donation" do 
    post reservation_cash_or_check_path(@reservation)
    assert_response :redirect
    assert flash[:notice] == "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  # donation choice #3
  test "should get no_donations" do
    post reservation_no_donation_path(@reservation)
    assert_redirected_to reservation_confirmed_url(@reservation)
  end

  # donation choice #4 - No linked reservation
  test "donation without reservation" do
    get donation_without_reservation_url 
    assert_response :redirect
  end

  # success, choice #1
  test "donation success with reservation" do
    post reservation_cash_or_check_path(reservation_id: @reservation.id)
    assert_response :redirect
    follow_redirect!
    assert flash[:notice].include? "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  #success, choice #2
  test "donation cash or check success" do 
    get reservation_success_url(@reservation)
    assert_response :success
  end

  # success, choice #4
  test "donation success without reservation" do
    get success_url
    assert_response :success
    assert flash[:notice].include? "Thank you! Your donation is greatly appreciated and goes a long way towards supporting Scouting on Bainbridge Island."
  end

  test "driver assisted donation success without reservation" do
    get success_url(driver: true)
    assert_response :success
  end
end
