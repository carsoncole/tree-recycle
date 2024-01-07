require 'test_helper'

class PostEventTaskTest < ActiveSupport::TestCase
  setup do
    TreeRecycle::Application.load_tasks
    Rake::Task['post_event:reset_and_archive_data'].invoke
  end

  test "event user data deleted" do
    assert_empty Log.all
    assert_empty Donation.all
    assert_empty Message.all
  end

end
