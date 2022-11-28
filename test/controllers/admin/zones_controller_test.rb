require "test_helper"

class Admin::ZonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @viewer = create(:viewer)
    @editor = create(:editor)
    @zone = create(:zone)
  end

  test "should get index checking auth" do
    get admin_zones_url
    assert_redirected_to sign_in_path

    get admin_zones_url(as: @viewer)
    assert_response :success
  end

  test "should get new" do
    get new_admin_zone_url(as: @viewer)
    assert_response :success
  end

  test "should create zone" do
    assert_difference("Zone.count") do
      post admin_zones_url(as: @editor), params: { zone:  attributes_for(:zone)  }
    end

    assert_redirected_to admin_zones_url
  end

  test "should not create zone as viewer" do
    assert_difference("Zone.count", 0) do
      post admin_zones_url(as: @viewer), params: { zone:  attributes_for(:zone)  }
    end

    assert_response :unauthorized
  end

  test "should get edit" do
    get edit_admin_zone_url(@zone, as: @viewer)
    assert_response :success
  end

  test "should update zone checking auth" do
    patch admin_zone_url(@zone), params: { zone: { name: 'Zone updated' } }
    assert_redirected_to sign_in_path

    patch admin_zone_url(@zone, as: @editor), params: { zone: { name: 'Zone updated' } }
    assert_redirected_to admin_zones_url
  end

  test "should not update zone as viewer" do
    patch admin_zone_url(@zone, as: @viewer), params: { zone: { name: 'Zone updated' } }
    assert_response :unauthorized
  end

  test "should destroy zone" do
    assert_difference("Zone.count", -1) do
      delete admin_zone_url(@zone, as: @editor)
    end

    assert_redirected_to admin_zones_url
  end

  test "should not destroy zone as viewer" do
    assert_difference("Zone.count", 0) do
      delete admin_zone_url(@zone, as: @viewer)
    end

    assert_response :unauthorized
  end

end
