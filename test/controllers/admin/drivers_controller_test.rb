require "test_helper"

class Admin::DriversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @viewer = create(:viewer)
    @editor = create(:editor)
    @driver = create(:driver)
  end

  test "should get index" do
    get admin_drivers_url(as: @viewer)
    assert_response :success
  end

  test "should get new" do
    get new_admin_driver_url(as: @viewer)
    assert_response :success
  end

  test "should create admin_driver" do
    assert_difference("Driver.count") do
      post admin_drivers_url(as: @editor), params: { driver: { name: 'John Doe', phone: '2055551212' }}
    end

    assert_redirected_to admin_drivers_url
  end

  test "should not create admin_driver as viewer" do
    assert_difference("Driver.count", 0) do
      post admin_drivers_url(as: @viewer), params: { driver: { name: 'John Doe', phone: '2055551212' }}
    end

    assert_response :unauthorized
  end

  test "should show admin_driver" do
    get admin_driver_url(@driver, as: @viewer)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_driver_url(@driver, as: @viewer)
    assert_response :success
  end

  test "should update admin_driver" do
    patch admin_driver_url(@driver, as: @editor), params: { driver: { name: 'New Name'  } }
    assert_redirected_to admin_drivers_url
  end

  test "should not update admin_driver as viewer" do
    patch admin_driver_url(@driver, as: @viewer), params: { driver: { name: 'New Name'  } }
    assert_response :unauthorized
  end

  test "should destroy admin_driver" do
    assert_difference("Driver.count", -1) do
      delete admin_driver_url(@driver, as: @editor)
    end

    assert_redirected_to admin_drivers_url
  end

  test "should not destroy admin_driver as viewer" do
    assert_difference("Driver.count", 0) do
      delete admin_driver_url(@driver, as: @viewer)
    end

    assert_response :unauthorized
  end
end
