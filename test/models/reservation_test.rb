require "test_helper"

class ReservationTest < ActiveSupport::TestCase
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
    reservation = build(:reservation, street: '1760 Susan Pl NW', city: 'Bainbridge Island', state: 'Washington', country: 'United States')
    assert_not reservation.geocoded?

    reservation.save
    assert reservation.geocoded?
  end

  test "setting and clearing of picked_up_at" do
    reservation = create(:reservation)

    assert_not reservation.is_picked_up
    assert_not reservation.picked_up_at

    reservation.update(is_picked_up: true)
    assert reservation.picked_up_at

    reservation.update(is_picked_up: false)
    assert_not reservation.picked_up_at
  end

  test "setting and clearing of is_missing_at" do
    reservation = create(:reservation)

    assert_not reservation.is_missing
    assert_not reservation.is_missing_at

    reservation.update(is_missing: true)
    assert reservation.is_missing_at

    reservation.update(is_missing: false)
    assert_not reservation.is_missing_at
  end
end
