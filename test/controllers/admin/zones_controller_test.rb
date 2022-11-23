require "test_helper"

class Admin::ZonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @zone = create(:zone)
  end

  test "should get index checking auth" do
    get admin_zones_url
    assert_redirected_to sign_in_path

    get admin_zones_url(as: @user)
    assert_response :success
  end

  test "should get new" do
    get new_admin_zone_url(as: @user)
    assert_response :success
  end

  test "should create zone" do
    assert_difference("Zone.count") do
      post admin_zones_url(as: @user), params: { zone:  attributes_for(:zone)  }
    end

    assert_redirected_to admin_zones_url
  end

  test "should get edit" do
    get edit_admin_zone_url(@zone, as: @user)
    assert_response :success
  end

  test "should update zone checking auth" do
    patch admin_zone_url(@zone), params: { zone: { name: 'Zone updated' } }
    assert_redirected_to sign_in_path

    patch admin_zone_url(@zone, as: @user), params: { zone: { name: 'Zone updated' } }
    assert_redirected_to admin_zones_url
  end

  test "should destroy zone" do
    assert_difference("Zone.count", -1) do
      delete admin_zone_url(@zone, as: @user)
    end

    assert_redirected_to admin_zones_url
  end
end
