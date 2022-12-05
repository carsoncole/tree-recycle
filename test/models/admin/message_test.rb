require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "creating valid message" do
    assert_difference('Message.count') do
      create(:message)
    end

    assert_not build(:message, number: nil).valid?
    assert_not build(:message, body: nil).valid?
  end

  test "normalizig of number" do
    message = create(:message, number: '206 555 1 212')
    assert_equal '+12065551212', message.number

    message = create(:message, number: '3035559850')
    assert_equal '+13035559850', message.number

    message = create(:message, number: '13035559850')
    assert_equal '+13035559850', message.number

    message = create(:message, number: '(206) 123-1234')
    assert_equal '+12061231234', message.number
  end
end
