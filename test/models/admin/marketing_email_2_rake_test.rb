require "test_helper"

class MarketingEmail2RakeTest < ActiveSupport::TestCase

  setup do
    # regular reservations that should NOT get the email
    create(:reservation_with_coordinates, status: 'picked_up', is_routed: false, email: 'bill@example.com')
    create(:reservation_with_coordinates, status: 'picked_up', is_routed: false, email: 'john@example.com')
    create(:reservation_with_coordinates, status: 'picked_up', is_routed: false, email: 'adam@example.com')

    # archived (2) reservations that should NOT get the email since they have regular reservations
    create(:archived_with_coordinates_reservation, is_routed: false, email: 'bill@example.com')
    create(:archived_with_coordinates_reservation, is_routed: false, email: 'adam@example.com')

    # archived (3) reservations that should get the email
    create(:archived_with_coordinates_reservation, is_routed: false, email: 'joe@example.com')
    create(:archived_with_coordinates_reservation, is_routed: false, email: 'sam@example.com')
    create(:archived_with_coordinates_reservation, is_routed: false, email: 'louie@example.com')
    
    # archived (5) and flagged as having already been sent the email
    create_list(:archived_with_coordinates_reservation, 5, is_routed: false, is_marketing_email_2_sent: true)

    TreeRecycle::Application.load_tasks
    ActionMailer::Base.deliveries = []
    Rake::Task['marketing:send_email_2_to_archived_customers'].invoke
  end

  test "marketing email 2 is sent to archived" do
    sleep 2
    assert_equal 10, Reservation.archived.count
    assert_equal 3, ActionMailer::Base.deliveries.count # count of emails to be sent

    # should get emails
    assert_includes Reservation.all.filter_map { |r| r.email if r.logs.where(message: 'Marketing email 2 sent to archived').any? }, 'joe@example.com'
    assert_includes Reservation.all.filter_map { |r| r.email if r.logs.where(message: 'Marketing email 2 sent to archived').any? }, 'louie@example.com'
    assert_includes Reservation.all.filter_map { |r| r.email if r.logs.where(message: 'Marketing email 2 sent to archived').any? }, 'sam@example.com'

    # should not get emails
    assert_not Reservation.all.filter_map { |r| r.email if r.logs.where(message: 'Marketing email 2 sent to archived').any? }.include? 'bill@example.com'
    assert_not Reservation.all.filter_map { |r| r.email if r.logs.where(message: 'Marketing email 2 sent to archived').any? }.include? 'adam@example.com'

    # no reservation should have logs indicating two email 2's went out
    assert_empty Reservation.all.filter_map { |r| r if r.logs.where(message: 'Marketing email 2 sent to archived').count > 1 }
  end
end
