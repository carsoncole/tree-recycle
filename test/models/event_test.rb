require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "uniqueness of reservation and event date" do
    event = create(:event)
    assert event
    assert create(:event)
    assert_not build(:event, reservation: event.reservation, date: event.date).valid?
  end
end
