require "test_helper"

class Admin::HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
  end

  test "should get index" do
    get admin_home_url(as: @user)
    assert_response :success
  end

  test "should not get index" do
    get admin_home_url
    assert_redirected_to sign_in_path
  end
end
