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

  test "should create reservation in step 1 with name, good address, and email" do
    new_reservation_attributes = build :reservation
    assert_difference("Reservation.count", 1) do
      post reservations_url, params: { reservation: { name: new_reservation_attributes.name, street: new_reservation_attributes.street, email: new_reservation_attributes.email } }
    end

    new_reservation = Reservation.order(updated_at: :asc).last

    assert new_reservation.pending_pickup?
  end

  test "should show reservation" do
    get reservation_url(@reservation)
    assert_response :success
  end


  test "should update reservation" do
    patch reservation_url(@reservation), params: { reservation: { city: @reservation.city, country: @reservation.country, email: @reservation.email, latitude: @reservation.latitude, longitude: @reservation.longitude, name: @reservation.name, phone: @reservation.phone, state: @reservation.state, street: @reservation.street, zip: @reservation.zip } }

    reservation = Reservation.order(updated_at: :asc).last
    assert_redirected_to new_reservation_donation_path(reservation)
  end

  test "should not destroy reservation" do
    assert_difference("Reservation.count", 0) do
      delete reservation_url(@reservation)
    end

    assert_redirected_to reservation_path(@reservation)
  end
end
