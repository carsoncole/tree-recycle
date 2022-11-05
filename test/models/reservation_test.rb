require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  test "setting of default status" do
    reservation = create(:reservation_with_coordinates)
    assert_equal reservation.status, 'pending_pickup'
  end

  test "name validation" do
    reservation = Reservation.new
    assert_not reservation.valid?
    assert reservation.errors.of_kind?(:name, :blank)
  end

  test "street address validation" do
    reservation = Reservation.new
    assert_not reservation.valid?
    assert reservation.errors.of_kind?(:street, :blank)
  end

  test "geocoding of new reservations" do
    reservation = build(:reservation_with_good_address)
    assert_not reservation.geocoded?
    reservation.save
    assert reservation.geocoded?
  end

  test "no geocoding of new reservation with coordinates provided" do
    reservation = build(:reservation_with_coordinates)
    assert reservation.geocoded? # geocoded by default

    reservation.street = 'pluto'
    reservation.save
    assert reservation.geocoded? # still geocoded
    assert_equal reservation.latitude, 47.6259654 # this would be reset to nil if geocoded again
  end
end
