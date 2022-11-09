require "test_helper"

class ReservationsMailerTest < ActionMailer::TestCase
  def setup
    create(:setting)
  end

  test "confirmed reservation email" do
    reservation = create(:reservation_with_coordinates)
    email = ReservationsMailer.with(reservation: reservation).confirmed_reservation_email

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Your tree pickup is confirmed", email.subject
    assert email.html_part.body.to_s.include? 'This email is to confirm that we will be picking up your tree on'
  end

  test "cancelled reservation email" do
    reservation = create(:reservation_with_coordinates)
    email = ReservationsMailer.with(reservation: reservation).cancelled_reservation_email

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Your tree pickup reservation is cancelled", email.subject
    assert email.html_part.body.to_s.include? 'If this cancellation is in error, please create a new reservation.'
  end

  test "hello email to archived" do
    reservation = create(:reservation_with_coordinates, status: 'archived')
    email = ReservationsMailer.with(reservation: reservation).hello_email

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
    email = ReservationsMailer.with(reservation: reservation).last_call_email

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Tree recycling last reminder for #{nice_long_date(Setting.first.pickup_date_and_time)}", email.subject
    assert email.html_part.body.to_s.include? "We noticed that you haven't signed up yet"
  end

  test "pick up reminder email" do
    reservation = create(:reservation_with_coordinates)
    email = ReservationsMailer.with(reservation: reservation).pick_up_reminder_email

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Reminder to put out your tree", email.subject
    assert email.html_part.body.to_s.include? 'This is a reminder that we will pick up your tree at'
  end

  test "delivery of email on confirmed email" do
    assert_emails 1 do
      reservation = create(:reservation_with_coordinates)
    end
  end

  test "delivery of email on cancelled reservation" do
    reservation = create(:reservation_with_coordinates)
    assert_emails 1 do
      reservation.cancelled!
    end
  end

  test "confirmed email non-delivery with bad address" do
    assert_emails 0 do
      @reservation = create(:reservation_with_bad_address)
    end
    assert_emails 1 do
      @reservation.pending_pickup!
    end

  end
end
