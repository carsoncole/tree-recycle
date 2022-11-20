require "test_helper"

class Admin::LogTest < ActiveSupport::TestCase
  def setup
    @reservation = create(:reservation_with_coordinates)
  end

  test "log on unconfirmed" do
    assert_difference("Log.all.count", 1) do
      @reservation.unconfirmed!
    end
    assert_equal "Reservation unconfirmed", @reservation.logs.last.message
  end

  test "log on pending pickup" do

    assert_equal 2, @reservation.logs.count # confirmed, confirmed email sent
    assert_equal "Tree is pending pickup", @reservation.logs.first.message
  end

  test "log on picked up" do
    assert_difference("Log.all.count", 1) do
      @reservation.picked_up!
    end
    assert_equal "Tree picked up", @reservation.logs.last.message
  end

  test "log on cancellation" do
    assert_difference("Log.all.count", 1) do
      @reservation.cancelled!
    end
    assert_equal "Reservation cancelled", @reservation.logs.last.message
  end

  test "log on missing" do
    assert_difference("Log.all.count", 1) do
      @reservation.missing!
    end
    assert_equal "Pickup attempted. Tree not found.", @reservation.logs.last.message
  end
end
