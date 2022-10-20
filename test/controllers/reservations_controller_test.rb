require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = create :reservation
  end

  test "should not get index" do
    get reservations_url
    assert_response :redirect
  end

  test "should get new" do
    get new_reservation_url
    assert_response :success
  end

  test "should create reservation" do
    new_reservation_attributes = build :reservation
    assert_difference("Reservation.count") do
      post reservations_url, params: { reservation: { city: new_reservation_attributes.city, country: new_reservation_attributes.country, email: new_reservation_attributes.email, latitude: new_reservation_attributes.latitude, longitude: new_reservation_attributes.longitude, name: new_reservation_attributes.name, phone: new_reservation_attributes.phone, state: new_reservation_attributes.state, street_1: new_reservation_attributes.street_1, street_2: new_reservation_attributes.street_2, zip: new_reservation_attributes.zip } }
    end

    new_reservation = Reservation.where(email: new_reservation_attributes.email).first

    assert_redirected_to reservation_url(new_reservation)
  end

  test "should show reservation" do
    get reservation_url(@reservation)
    assert_response :success
  end

  test "should not get edit" do
    get edit_reservation_url(@reservation)
    assert_response :redirect
  end

  test "should not update reservation" do
    patch reservation_url(@reservation), params: { reservation: { city: @reservation.city, country: @reservation.country, email: @reservation.email, latitude: @reservation.latitude, longitude: @reservation.longitude, name: @reservation.name, phone: @reservation.phone, state: @reservation.state, street_1: @reservation.street_1, street_2: @reservation.street_2, zip: @reservation.zip } }
    assert_redirected_to sign_in_path
  end

  test "should not destroy reservation" do
    assert_difference("Reservation.count", 0) do
      delete reservation_url(@reservation)
    end

    assert_redirected_to sign_in_path
  end
end
