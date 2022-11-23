require "test_helper"

class Admin::RoutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @route = create(:route_with_coordinates, is_zoned: false)
    @user = create(:user)
  end

  test "should not get index" do
    get admin_routing_url
    assert_redirected_to sign_in_path
  end

  test "should get index" do
    get admin_routing_url(as: @user)
    assert_response :success
  end

  test "should get new" do
    get new_admin_route_url(as: @user)
    assert_response :success
  end

  test "should create route" do
    assert_difference("Route.count") do
      post admin_routes_url(as: @user), params: { route: attributes_for(:route) }
    end

    assert_redirected_to admin_routing_url
  end

  test "should show route" do
    get admin_route_url(@route, as: @user)
    assert_response :success
  end

  test "should not show route without auth" do
    get admin_route_url(@route)
    assert_redirected_to sign_in_path
  end

  test "should get edit" do
    get edit_admin_route_url(@route, as: @user)
    assert_response :success
  end

  test "should update route" do
    patch admin_route_url(@route, as: @user), params: { route: { name: "New Name" } }
    assert_redirected_to admin_routing_url
  end

  test "should destroy route" do
    assert_difference("Route.count", -1) do
      delete admin_route_url(@route, as: @user)
    end

    assert_redirected_to admin_routing_url
  end
end
