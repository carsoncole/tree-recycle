require "test_helper"

class Admin::LogTest < ActiveSupport::TestCase
  def setup
    @reservation = create(:reservation_with_coordinates)
  end

  test "log on unconfirmed" do
    @reservation.unconfirmed!
    assert_equal 2, @reservation.logs.count
    assert_equal "Reservation unconfirmed", @reservation.logs.last.message
  end

  test "log on pending pickup" do
    assert_equal 1, @reservation.logs.count # confirmed, confirmed email sent
    assert_equal "Tree is pending pickup", @reservation.logs.first.message
  end

  test "log on picked up" do
    @reservation.picked_up!
    assert_equal 2, @reservation.logs.count
    assert_equal "Tree picked up", @reservation.logs.last.message
  end

  test "log on cancellation" do
    @reservation.cancelled!
    assert_equal 2, @reservation.logs.count
    assert_equal "Reservation cancelled", @reservation.logs.last.message
  end

  test "log on missing" do
    @reservation.missing!
    assert_equal 2, @reservation.logs.count
    assert_equal "Pickup attempted. Tree not found.", @reservation.logs.last.message
  end
end
