require "test_helper"

class MarketingRakeTest < ActiveSupport::TestCase

  setup do
    create_list(:reservation_with_coordinates, 10, status: 'picked_up', is_routed: false)
    create_list(:reservation_with_coordinates, 15, status: 'archived', is_routed: false)
    TreeRecycle::Application.load_tasks
    Rake::Task['marketing:send_email_1_to_archived_customers'].invoke
  end

  test "marketing email 1 is sent to archived" do
    assert_equal 15, Log.where(message: 'Marketing email 1 sent to archived').count
    assert_equal 15, ActionMailer::Base.deliveries.count
  end


end
y
