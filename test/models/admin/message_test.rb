require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "creating valid message" do
    assert_difference('Message.count') do
      create(:message)
    end

    assert_not build(:message, phone: nil).valid?
    assert_not build(:message, body: nil).valid?
  end

  test "normalizig of phone" do
    message = create(:message, phone: '206 555 1 212')
    assert_equal '+12065551212', message.phone

    message = create(:message, phone: '3035559850')
    assert_equal '+13035559850', message.phone

    message = create(:message, phone: '13035559850')
    assert_equal '+13035559850', message.phone

    message = create(:message, phone: '(206) 123-1234')
    assert_equal '+12061231234', message.phone
  end
end
