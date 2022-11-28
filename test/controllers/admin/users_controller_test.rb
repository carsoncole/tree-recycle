require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator = create(:administrator)
    @editor = create(:editor)
  end

  test "users index" do 
    get admin_users_path(as: @administrator)
    assert_response :success
  end

  test "users index without correct role" do 
    get admin_users_path(as: @editor)
    assert_redirected_to sign_in_path
  end

  test "users index without user" do 
    get admin_users_path
    assert_redirected_to sign_in_path
  end

  test "updating user" do 
    patch admin_user_path(@editor, as: @administrator), params: { user: { role: 'administrator' } }
    assert_redirected_to admin_users_path
    assert_equal 'administrator', @editor.reload.role 
  end

  test "updating user as editor" do 
    patch admin_user_path(@administrator, as: @editor), params: { user: { role: 'viewer' } }
    assert_redirected_to sign_in_path
    assert_equal 'administrator', @administrator.reload.role 
  end

end