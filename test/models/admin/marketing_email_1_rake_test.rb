require "test_helper"

class MarketingEmail1RakeTest < ActiveSupport::TestCase

  setup do
    setting.update(is_emailing_enabled: false)
    # 20 pending_pickup reservations
    pending = create_list(:reservation_with_coordinates, 20, status: 'pending_pickup', is_routed: false)
    # 5 archived, no_emails reservations
    create_list(:reservation_with_coordinates, 5, status: 'archived', is_routed: false, no_emails: true)
    # 5 archived, is_sent_marketing_email_1 = true  reservations
    create_list(:reservation_with_coordinates, 5, status: 'archived', is_routed: false, is_marketing_email_1_sent: true)
    # 10 archived reservations
    create_list(:reservation_with_coordinates, 10, status: 'archived', is_routed: false)
    # 5 archived, but with existing reservations
    pending[0..4].each { |r| create(:reservation_with_coordinates, email: r.email, status: 'archived', is_routed: false)}
    setting.update(is_emailing_enabled: true)

    TreeRecycle::Application.load_tasks
    ActionMailer::Base.deliveries = []
    Rake::Task['marketing:send_email_1_to_archived_customers'].invoke
  end

  test "marketing email 1 is sent to archived" do
    assert_equal 25, Reservation.archived.count
    assert_equal 10, ActionMailer::Base.deliveries.count # count of emails to be sent

    # no reservation should have logs indicating two email 1's went out
    assert_empty Reservation.all.filter_map { |r| r if r.logs.where(message: 'Marketing email 1 sent to archived').count > 1 }
  end
end
