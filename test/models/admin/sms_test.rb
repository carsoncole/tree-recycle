require "test_helper"

class Admin::SmsTest < ActiveSupport::TestCase


  test "sending a sms to a reservation with a number" do 
    reservation = create(:reservation_with_coordinates, is_routed: false, phone: '2065551212')
    assert Sms.new.send(reservation, "This is a test message")
  end

  test "sending a sms to a reservation without a number" do 
    reservation = create(:reservation_with_coordinates, is_routed: false)
    assert_not Sms.new.send(reservation, "This is a test message")
  end

  test "sending a sms to a reservation with an invalid number" do 
    reservation = create(:reservation_with_coordinates, is_routed: false, phone: '+15005550001')
    assert Sms.new.send(reservation, "This is a test message")
  end

end

