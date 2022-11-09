require "test_helper"

class LogTest < ActiveSupport::TestCase
  def setup
    @reservation = create(:reservation_with_coordinates)
  end

  test "log creation on new reservations" do
    assert_equal @reservation.logs.count, 1
    assert_equal @reservation.logs.first.message, "Reservation created"

    assert_difference("Log.all.count", 1) do
      reservation = create(:reservation_with_coordinates)
    end
  end

  test "log creation on cancellation" do
    assert_difference("Log.all.count", 1) do
      @reservation.cancelled!
    end
    assert_equal @reservation.logs.last.message, "Reservation cancelled"
  end

  test "log creation on picked up" do
    assert_difference("Log.all.count", 1) do
      @reservation.picked_up!
    end
    assert_equal @reservation.logs.last.message, "Tree picked up"
  end

  test "log creation on missing" do
    assert_difference("Log.all.count", 1) do
      @reservation.missing!
    end
    assert_equal @reservation.logs.last.message, "Pickup attempted. Tree not found."
  end

  test "log creation should not occur on change to pending pickup since its the default" do
    assert_difference("Log.all.count", 0) do
      @reservation.pending_pickup!
    end
  end
end
