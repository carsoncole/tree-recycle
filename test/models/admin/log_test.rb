require "test_helper"

class Admin::LogTest < ActiveSupport::TestCase
  def setup
    @reservation = create(:reservation_with_coordinates)
    setting.update(is_emailing_enabled: true)
    sleep 1
  end

  test "log on unconfirmed" do
    assert_difference("Reservation.unconfirmed.count", 1) do
      @reservation.unconfirmed!
      sleep 0.25
    end
    assert_equal "Reservation unconfirmed.", @reservation.logs.last.message
  end

  #OPTIMIZE messages no longer queued?
  test "log on pending pickup" do
    assert_equal 1, @reservation.logs.count
    assert_equal 1, enqueued_jobs.count
    # assert_equal "Tree is pending pickup", @reservation.logs.first.message
  end

  test "log on picked up" do
    assert_difference("Reservation.picked_up.count", 1) do
      @reservation.picked_up!
      sleep 0.25
    end
    assert_equal "Tree picked up.", @reservation.logs.last.message
  end

  #OPTIMIZE messages no longer queued?
  test "log on cancellation" do
    assert_difference("Reservation.cancelled.count", 1) do  # cancelled log
      @reservation.cancelled!
    end
    sleep 0.5 
    # assert_equal "Cancelled reservation email sent.", @reservation.logs.last.message
  end

  test "log on missing" do
    assert_difference("Reservation.missing.count", 1) do # status change log, email notification log
      @reservation.missing!
    end
    assert_equal "Pickup attempted. Tree not found.", @reservation.logs.last.message
  end

  test "log on archived" do
    assert_difference("Reservation.archived.count", 1) do # status change log, email notification log
      @reservation.archived!
      sleep 0.5
    end
  end
end
