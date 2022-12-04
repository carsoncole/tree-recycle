require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "creating valid message" do
    assert_difference('Message.count') do
      create(:message)
    end

    assert_not create(:message, number: nil)
    assert_not create(:message, body: nil)
  end

  test "sending a message" do

  end
end
