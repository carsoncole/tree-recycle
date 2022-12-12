require "test_helper"

class ReservationsMailerTest < ActionMailer::TestCase
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

    assert_equal ["bainbridgeislandscouts@gmail.com"], email.from
    assert_equal [reservation.email], email.to
    assert_equal "Your tree pickup reservation has been cancelled", email.subject
    assert email.html_part.body.to_s.include? 'If this cancellation is in error, please create a new reservation.'
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

  test "delivery of emails on status changes" do
    assert_emails 1 do # confirmed
      @reservation = create(:reservation_with_coordinates)
    end

    assert_equal ActionMailer::Base.deliveries.last.subject, "Your tree pickup is confirmed"

    assert_emails 0 do
      @reservation.unconfirmed!
    end

    assert_emails 0 do # only 1 confirmed will be sent
      @reservation.pending_pickup!
    end
    assert_equal ActionMailer::Base.deliveries.last.subject, "Your tree pickup is confirmed"

    assert_emails 1 do
      @reservation.cancelled!
    end
    assert_equal "Your tree pickup reservation has been cancelled", ActionMailer::Base.deliveries.last.subject

    assert_emails 0 do # confirmed emails only sent once
      @reservation.pending_pickup!
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
