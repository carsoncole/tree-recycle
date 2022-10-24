require "test_helper"

class Admin::ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = create :reservation
    @user = create :user
  end

  test "should get index" do
    get admin_reservations_url(as: @user)
    assert_response :success

    assert_select "h1", 'Reservations'
  end

  test "should not get index without auth" do
    get admin_reservations_url
    assert_redirected_to sign_in_path
  end

  test "should get show with auth" do
    get admin_reservation_url(@reservation, as: @user)
    assert_response :success
  end

  test "should not get show without auth" do
    get admin_reservation_url(@reservation)
    assert_redirected_to sign_in_path
  end


end
