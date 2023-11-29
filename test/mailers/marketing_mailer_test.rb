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
    assert_equal "Tree recycling #{nice_long_date_short(Time.parse(EVENT_DATE_AND_PICKUP_TIME))}. Register today.", email.subject
    assert email.html_part.body.to_s.include? "We've picked up up your tree in the past, and if you would like us to pick up again this year, please let us know by registering on our website"
  end

  test "marketing email 2" do
    reservation = create(:reservation_with_coordinates, status: 'archived')
    email = MarketingMailer.with(reservation: reservation).marketing_email_2

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Last call! Tree recycling #{nice_long_date_short(Time.parse(EVENT_DATE_AND_PICKUP_TIME))}", email.subject
    assert email.html_part.body.to_s.include? "We noticed you have not signed up this year"
  end
end
