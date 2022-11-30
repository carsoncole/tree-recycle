require "test_helper"

class Admin::RoutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @route = create(:route_with_coordinates, is_zoned: false)
    @viewer = create(:viewer)
    @editor = create(:editor)
  end

  test "should not get index" do
    get admin_routing_url
    assert_redirected_to sign_in_path
  end

  test "should get index" do
    get admin_routing_url(as: @viewer)
    assert_response :success
  end

  test "should get new" do
    get new_admin_route_url(as: @viewer)
    assert_response :success
  end

  test "should create route" do
    assert_difference("Route.count") do
      post admin_routes_url(as: @editor), params: { route: attributes_for(:route) }
    end

    assert_redirected_to admin_routing_url
  end

  test "should not create route as viewer" do
    assert_difference("Route.count", 0) do
      post admin_routes_url(as: @viewer), params: { route: attributes_for(:route) }
    end

    assert_response :unauthorized
  end

  test "should get edit" do
    get edit_admin_route_url(@route, as: @viewer)
    assert_response :success
  end

  test "should update route" do
    patch admin_route_url(@route, as: @editor), params: { route: { name: "New Name" } }
    assert_redirected_to admin_routing_url
  end

  test "should not update route as viewer" do
    patch admin_route_url(@route, as: @viewer), params: { route: { name: "New Name" } }
    assert_response :unauthorized
  end

  test "should destroy route" do
    assert_difference("Route.count", -1) do
      delete admin_route_url(@route, as: @editor)
    end

    assert_redirected_to admin_routing_url
  end

  test "should not destroy route as viewer" do
    assert_difference("Route.count", 0) do
      delete admin_route_url(@route, as: @viewer)
    end

    assert_response :unauthorized
  end
end
