require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = create :reservation
    @user = create :user
  end

  test "should get new" do
    get new_reservation_url
    assert_response :success
  end

  test "should create reservation in step 1 with name and address" do
    new_reservation_attributes = build :reservation
    assert_difference("Reservation.count") do
      post reservations_url, params: { reservation: { name: new_reservation_attributes.name, street: new_reservation_attributes.street } }
    end

    new_reservation = Reservation.order(updated_at: :asc).last

    assert_redirected_to reservation_form_2_url(new_reservation)
  end

  test "should show reservation" do
    get reservation_url(@reservation)
    assert_response :success
  end

  test "should get form 1" do
    get reservation_form_1_url(@reservation)
    assert_response :success
  end

  test "should get form 2" do
    get reservation_form_1_url(@reservation)
    assert_response :success
  end

  test "should update reservation" do
    patch reservation_url(@reservation), params: { reservation: { city: @reservation.city, country: @reservation.country, email: @reservation.email, latitude: @reservation.latitude, longitude: @reservation.longitude, name: @reservation.name, phone: @reservation.phone, state: @reservation.state, street: @reservation.street, zip: @reservation.zip } }

    reservation = Reservation.order(updated_at: :asc).last
    assert_redirected_to reservation_path(reservation)
  end

  test "should not destroy reservation" do
    assert_difference("Reservation.count", 0) do
      delete reservation_url(@reservation)
    end

    assert_redirected_to sign_in_path
  end

  # admin

  test "should get index with auth" do
    get admin_reservations_url(as: @user)
    assert_response :success
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

  test "should get map with auth" do
    get admin_map_path(as: @user)
    assert_response :success
  end

  test "should not get map without auth" do
    get admin_map_path
    assert_redirected_to sign_in_path
  end

end
