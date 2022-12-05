require "test_helper"

class Admin::SmsTest < ActiveSupport::TestCase


  test "sending a sms to a reservation with a number" do 
    reservation = create(:reservation_with_coordinates, is_routed: false, no_emails: true, phone: '+12054517216')
    sleep 0.5
    assert_difference('reservation.logs.count') do
     Sms.new.send_with_object(reservation, "This is a test message")
     sleep 1
    end
  end

  #FIXME Tests overwrite numbers so this needs fixing
  # test "sending a sms to a reservation without a number" do
  #   reservation = create(:reservation_with_coordinates, is_routed: false)
  #   assert_not Sms.new.send(reservation, "This is a test message")
  # end

  test "sending a sms to a reservation with an invalid number" do 
    reservation = create(:reservation_with_coordinates, is_routed: false, no_emails: true, phone: '+12054517216')
    sleep 0.5
    assert_difference("reservation.logs.count") do
      Sms.new.send_with_object(reservation, "This is a test message")
      sleep 1
    end
  end

  #FIXME not complete--need to figure out how to add twilio responses
  test "sending an sms" do
    assert create(:message)
  end

end

