require "test_helper"

class MarketingMailerTest < ActionMailer::TestCase
  test "hello email to archived" do
    reservation = create(:reservation_with_coordinates, status: 'archived')
    email = MarketingMailer.with(reservation: reservation).hello_email

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Tree recycling on #{nice_long_date(Setting.first.pickup_date_and_time)}", email.subject
    assert email.html_part.body.to_s.include? 'We are sending a friendly reminder that the Scouts of Bainbridge Island Troop 1564'
  end

  test "last call email to archived" do
    reservation = create(:reservation_with_coordinates, status: 'archived')
    email = MarketingMailer.with(reservation: reservation).last_call_email

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Tree recycling last reminder for #{nice_long_date(Setting.first.pickup_date_and_time)}", email.subject
    assert email.html_part.body.to_s.include? "We noticed that you haven't signed up yet"
  end
end