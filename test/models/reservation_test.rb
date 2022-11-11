require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  test "setting of default status" do
    reservation = create(:reservation_with_coordinates)
    assert_equal reservation.status, 'pending_pickup'
    assert reservation.geocoded?
  end

  test "name validation" do
    reservation = build(:reservation_with_coordinates, name: nil)
    assert_not reservation.valid?
    assert reservation.errors.of_kind?(:name, :blank)
  end

  test "street address validation" do
    reservation = build(:reservation_with_coordinates, street: nil)
    assert_not reservation.valid?
    assert reservation.errors.of_kind?(:street, :blank)
  end

  test "geocoding of new reservations" do
    reservation = build(:reservation)
    assert_not reservation.geocoded?
    reservation.save
    assert reservation.geocoded?
  end

  test "re-geocoding on updated reservations" do
    reservation = create(:reservation_with_coordinates)
    lat, lon = reservation.latitude, reservation.longitude
    reservation.update(street: '1760 Susan Place NW')
    assert_not_equal reservation.latitude, lat
    assert reservation.geocoded?
    assert_not_equal lat, reservation.latitude
    assert_equal reservation.latitude, 47.64001144897959
  end

  test "no geocoding of new reservation with coordinates provided" do
    reservation = build(:reservation_with_coordinates)
    assert reservation.geocoded? # geocoded by default

    reservation.street = 'pluto'
    reservation.save
    assert reservation.geocoded? # still geocoded
    assert_equal reservation.latitude, 47.6259654 # this would be reset to nil if geocoded again
  end

  test "re-routing on updated reservations" do
  end
end
