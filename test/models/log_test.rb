require "test_helper"

class LogTest < ActiveSupport::TestCase
  def setup
    @reservation = create(:reservation)
  end

  test "log creation on new reservations" do
    assert_equal @reservation.logs.count, 1
    assert_equal @reservation.logs.first.message, "Reservation created"

    assert_difference("Log.count", 1) do
      reservation = create(:reservation)
    end
  end

  test "log creation on cancellation" do
    assert_difference("Log.count", 1) do
      @reservation.update(is_cancelled: true)
    end
    assert_equal @reservation.logs.last.message, "Reservation cancelled"
  end

  test "log creation on picked up" do
    assert_difference("Log.count", 1) do
      @reservation.update(is_picked_up: true)
    end
    assert_equal @reservation.logs.last.message, "Tree picked up"
  end

  test "log creation on missing" do
    assert_difference("Log.count", 1) do
      @reservation.update(is_missing: true)
    end
    assert_equal @reservation.logs.last.message, "Pickup attempted. Tree not found."
  end
end
