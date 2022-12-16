require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @administrator = create(:administrator)
    @viewer = create(:viewer)
    @editor = create(:editor)
  end

  test "users index" do 
    get admin_users_path(as: @viewer)
    assert_response :success

    get admin_users_path(as: @editor)
    assert_response :success

    get admin_users_path(as: @administrator)
    assert_response :success
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
    assert_redirected_to admin_users_path
    assert_equal 'administrator', @administrator.reload.role
  end

  test "creating a user" do 
    assert_difference('User.count') do 
      post admin_users_path(as: @administrator), params: { user: attributes_for(:user) }
    end
    assert_redirected_to admin_users_path

    assert_difference('User.count', 0) do 
      post admin_users_path(as: @viewer), params: { user: attributes_for(:editor) }
    end
    assert_redirected_to admin_users_path

    assert_difference('User.count', 0) do 
      post admin_users_path(as: @editor), params: { user: attributes_for(:administrator) }
    end
    assert_redirected_to admin_users_path
  end

end