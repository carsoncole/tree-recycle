require "test_helper"

class Admin::MessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_messages_index_url
    assert_response :success
  end

  test "should get create" do
    get admin_messages_create_url
    assert_response :success
  end
end
