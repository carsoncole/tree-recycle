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
    assert reservation.errors.of_kind?(:street_1, :blank)
  end

end
