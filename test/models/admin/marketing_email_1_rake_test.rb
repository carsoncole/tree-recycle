require "test_helper"

class MarketingEmailRakeTest < ActiveSupport::TestCase

  #OPTIMIZE queued email jobs need work
  test "collection of marketing emails" do 
    # 4 pending_pickup reservations
    pending_pickups = create_list(:reservation_with_coordinates, 20, status: 'pending_pickup', is_routed: false)    

    # 1 archived, no_emails reservations
    create(:reservation_with_coordinates, status: 'archived', is_routed: false, no_emails: true)

    # 1 unconfirmed reservation
    create(:reservation_with_coordinates, email: 'sammy@example.com', status: 'archived', is_routed: false)

    # INCLUDED - 1 archived, but same as 1 unconfirmed reservation
    create(:reservation_with_coordinates, email: 'sammy@example.com', status: 'unconfirmed', is_routed: false)

    # 2 archived, is_sent_marketing_email_1 = true  reservations
    create_list(:reservation_with_coordinates, 2, status: 'archived', is_routed: false, is_marketing_email_1_sent: true)

    # INCLUDED - 3 archived reservations
    archived = create_list(:reservation_with_coordinates, 3, status: 'archived', is_routed: false)

    # 2 archived, but with existing reservations
    pending_pickups[0..1].each { |r| create(:reservation_with_coordinates, email: r.email, status: 'archived', is_routed: false)}

    sleep 5
    ActionMailer::Base.deliveries = []

    assert_equal 4, Reservation.reservations_to_send_marketing_emails('is_marketing_email_1_sent').count
    assert_equal 6, Reservation.reservations_to_send_marketing_emails('is_marketing_email_2_sent').count

    assert_equal 0, ActionMailer::Base.deliveries.count
    TreeRecycle::Application.load_tasks

    assert_difference "enqueued_jobs.size", 4 do
      Rake::Task['marketing:send_email_1_to_archived_customers'].invoke
    end
    sleep 1

    # assert_equal 4, ActionMailer::Base.deliveries.count # count of emails to be sent
    Rake::Task['marketing:send_email_2_to_archived_customers'].invoke
    sleep 2

    # assert_equal 6, Reservation.where(is_marketing_email_2_sent: true).count
    # assert Reservation.where(is_marketing_email_1_sent: true).map{|r| r.email }.include? 'sammy@example.com'
  end

end
