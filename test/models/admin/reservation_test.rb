require "test_helper"

class Admin::ReservationTest < ActiveSupport::TestCase

  test "process post event" do
    new_reservations = create_list(:reservation_picked_up, 10, is_pickup_reminder_email_sent: true)
    reservation_1 = create(:reservation_picked_up, email: 'duplicity@gmail.com', is_missing_tree_email_sent: true)
    reservation_2 = create(:reservation_picked_up, email: new_reservations[1].email, is_marketing_email_1_sent: true)

    archived_reservations = create_list(:archived_reservation, 10, is_marketing_email_1_sent: true, is_marketing_email_2_sent: true)
    create(:archived_reservation, email: 'duplicity@gmail.com')
    create(:archived_reservation, email: archived_reservations[1].email)
    create(:archived_reservation, email: archived_reservations[1].email)
    create(:archived_reservation, email: archived_reservations[2].email)

    create_list(:unsubscribed_reservation, 5)
    create_list(:unconfirmed_reservation, 3)

    assert_equal 12, Reservation.picked_up.count
    assert_equal 19, Reservation.archived.count
    assert_equal 5, Reservation.unsubscribed.count
    assert_equal 3, Reservation.unconfirmed.count
    assert_equal 4, Reservation.duplicate_email.count

    assert_difference "Reservation.active.count", -12 do
      Reservation.process_post_event_reservations!
    end
    assert_empty Reservation.unconfirmed
    assert_empty Reservation.unsubscribed
    assert_empty Reservation.active
    assert_equal 21, Reservation.archived.count
    assert_empty Reservation.where(is_marketing_email_1_sent: true)
    assert_empty Reservation.where(is_marketing_email_2_sent: true)
    assert_empty Reservation.duplicate_email
    assert_equal reservation_1, Reservation.where(email: 'duplicity@gmail.com').first

    # emails flags should be reset
    assert_empty Reservation.where(is_marketing_email_1_sent: true).or(Reservation.where(is_marketing_email_2_sent: true)).or(Reservation.where(is_confirmed_reservation_email_sent: true)).or(Reservation.where(is_missing_tree_email_sent: true)).or(Reservation.where(is_pickup_reminder_email_sent: true))
  end

end
