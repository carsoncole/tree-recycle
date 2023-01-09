require "test_helper"

class Admin::MarketingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @viewer = create(:viewer)
    @editor = create(:editor)
    @administrator = create(:administrator)
  end

  test "viewing index as admin" do
    get admin_marketing_index_path(as: @administrator)
    assert_response :success
  end

  test "viewing index as viewer" do
    get admin_marketing_index_path(as: @viewer)
    assert_response :success
  end

  test "viewing index as editor" do
    get admin_marketing_index_path(as: @editor)
    assert_response :success
  end

  test "viewing index" do
    get admin_marketing_index_path
    assert_redirected_to sign_in_path
  end
end
