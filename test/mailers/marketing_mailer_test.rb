require "test_helper"

class MarketingMailerTest < ActionMailer::TestCase
  test "marketing email 1" do
    reservation = create(:reservation_with_coordinates, status: 'archived')
    email = MarketingMailer.with(reservation: reservation).marketing_email_1

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Tree recycling on #{nice_long_date(Setting.first.pickup_date_and_time)}", email.subject
    assert email.html_part.body.to_s.include? "It's our 26th year of recycling Christmas trees on Bainbridge"
  end

  test "marketing email 2" do
    reservation = create(:reservation_with_coordinates, status: 'archived')
    email = MarketingMailer.with(reservation: reservation).marketing_email_2

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Tree recycling last reminder for #{nice_long_date(Setting.first.pickup_date_and_time)}", email.subject
    assert email.html_part.body.to_s.include? "We noticed that you haven't signed up yet"
  end
end