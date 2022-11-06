require "test_helper"

#TODO mailers tests
class ReservationsMailerTest < ActionMailer::TestCase
  test "confirmed reservation email" do
    # Create the email and store it for further assertions
    reservation = create(:reservation_with_coordinates)
    email = ReservationsMailer.with(reservation: reservation).confirmed_reservation_email

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Your tree pickup is confirmed", email.subject
    assert email.html_part.body.to_s.include? 'This email is to confirm that we will pick up your tree at'
  end

  test "cancelled reservation email" do
    # Create the email and store it for further assertions
    reservation = create(:reservation_with_coordinates)
    email = ReservationsMailer.with(reservation: reservation).cancelled_reservation_email

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Your tree pickup reservation is cancelled", email.subject
    assert email.html_part.body.to_s.include? 'If this cancellation is in error, please create a new reservation.'
  end

  test "hello email" do
    # Create the email and store it for further assertions
    reservation = create(:reservation_with_coordinates)
    email = ReservationsMailer.with(reservation: reservation).hello_email

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Tree recycling on #{nice_long_date(Setting.first.pickup_date_and_time)}", email.subject
    assert email.html_part.body.to_s.include? 'We are sending a friendly reminder that the Scouts of Bainbridge Island Troop 1564'
  end

  test "last call email" do
    # Create the email and store it for further assertions
    reservation = create(:reservation_with_coordinates)
    email = ReservationsMailer.with(reservation: reservation).last_call_email

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Tree recycling last reminder for #{nice_long_date(Setting.first.pickup_date_and_time)}", email.subject
    assert email.html_part.body.to_s.include? "We noticed that you haven't signed up yet"
  end

  test "pick up reminder email" do
    # Create the email and store it for further assertions
    reservation = create(:reservation_with_coordinates)
    email = ReservationsMailer.with(reservation: reservation).pick_up_reminder_email

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Reminder to put out your tree", email.subject
    assert email.html_part.body.to_s.include? 'This is a reminder that we will pick up your tree at'
  end
end
