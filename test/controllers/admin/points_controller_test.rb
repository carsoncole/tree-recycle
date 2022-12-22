require "test_helper"

class Admin::PointsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    @editor = create(:editor)
    @point = create(:point)
    @route = @point.route
  end

  test "should get create" do
    post admin_points_url(as: @editor), params: { point: { route_id: @route.id, latitude: 0, longitude: 0 } }
    assert_redirected_to edit_admin_route_path(@route)
  end

  test "should get update" do
    patch admin_point_url(@point, as: @editor), params: { point: { latitude: 1 } }
    assert_redirected_to edit_admin_route_path(@route)
  end

  test "should get destroy" do
    delete admin_point_url(@point, as: @editor)
    assert_redirected_to edit_admin_route_path(@route)
  end
end
