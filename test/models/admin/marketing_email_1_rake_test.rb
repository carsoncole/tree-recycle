require "test_helper"

class MarketingEmailRakeTest < ActiveSupport::TestCase

  #OPTIMIZE Needs to be reworked in light of now merging archive
  #OPTIMIZE queued email jobs need work
  test "collection of marketing emails" do 
    # 1 archived, no_emails reservation
    # 2 archived
    create(:reservation_with_coordinates, status: 'archived', is_routed: false, no_emails: true)
    create(:reservation_with_coordinates, email: 'CarsonCole@example.com', status: 'archived', is_routed: false)
    create(:reservation_with_coordinates, email: 'JACKJONES@EXAMPLE.COM', status: 'archived', is_routed: false)

    # 20 pending_pickup reservations
    pending_pickups = create_list(:reservation_with_coordinates, 20, status: 'pending_pickup', is_routed: false)    

    # # 2 pending_pickups with capitalized emails, 2 of same archived with different case
    # pending_3 = create(:reservation_with_coordinates, email: 'carsoncole@example.com', status: 'pending_pickup', is_routed: false)
    # pending_4 = create(:reservation_with_coordinates, email: 'jackjones@example.com', status: 'pending_pickup', is_routed: false)


    # # 1 archived reservation with no current reservation
    # create(:reservation_with_coordinates, email: 'sammy@example.com', status: 'archived', is_routed: false)

    # 1 unconfirmed reservation
    create(:reservation_with_coordinates, email: 'sammy@example.com', status: 'unconfirmed', is_routed: false)

    # 2 archived, is_sent_marketing_email_1 = true  reservations
    create_list(:reservation_with_coordinates, 2, status: 'archived', is_routed: false, is_marketing_email_1_sent: true)

    sleep 4
    ActionMailer::Base.deliveries = []

    assert_equal 2, Reservation.reservations_to_send_marketing_emails('is_marketing_email_1_sent').count
    assert_equal 4, Reservation.reservations_to_send_marketing_emails('is_marketing_email_2_sent').count

    assert_equal 0, ActionMailer::Base.deliveries.count
    TreeRecycle::Application.load_tasks

    assert_difference "enqueued_jobs.size", 2 do
      Rake::Task['marketing:send_email_1_to_archived_customers'].invoke
    end
    sleep 1

    # assert_equal 4, ActionMailer::Base.deliveries.count # count of emails to be sent
    assert_difference "enqueued_jobs.size", 4 do
      Rake::Task['marketing:send_email_2_to_archived_customers'].invoke
    end
    # sleep 2

    # assert_equal 6, Reservation.where(is_marketing_email_2_sent: true).count
    # assert Reservation.where(is_marketing_email_1_sent: true).map{|r| r.email }.include? 'sammy@example.com'
  end

end
