require "test_helper"

class ZonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @zone = create(:zone)
    @user = create(:user)
  end

  test "should not get index" do
    get admin_zones_url
    assert_redirected_to sign_in_path
  end

  test "should get index" do
    get admin_zones_url(as: @user)
    assert_response :success
  end

  test "should get new" do
    get new_admin_zone_url(as: @user)
    assert_response :success
  end

  test "should create zone" do
    assert_difference("Zone.count") do
      post admin_zones_url(as: @user), params: { zone: { street: @zone.street, city: @zone.city, state: @zone.state, distance: @zone.distance, name: @zone.name } }
    end

    assert_redirected_to admin_zones_url
  end

  test "should show zone" do
    get admin_zone_url(@zone, as: @user)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_zone_url(@zone, as: @user)
    assert_response :success
  end

  test "should update zone" do
    patch admin_zone_url(@zone, as: @user), params: { zone: { street: @zone.street, city: @zone.city, state: @zone.state, distance: @zone.distance, name: @zone.name } }
    assert_redirected_to admin_zones_url
  end

  test "should destroy zone" do
    assert_difference("Zone.count", -1) do
      delete admin_zone_url(@zone, as: @user)
    end

    assert_redirected_to admin_zones_url
  end
end
