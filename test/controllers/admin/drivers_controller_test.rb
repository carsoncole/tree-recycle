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

  test "assigning and removing a driver route" do 
    create_list(:route_with_coordinates, 2)

    post admin_driver_routes_path(driver_route: { driver_id: @driver.id, route_id: Route.first.id }, as: @editor)
    assert_redirected_to edit_admin_driver_url(@driver)

    assert_equal 1, @driver.driver_routes.count
    delete admin_driver_route_path(@driver.driver_routes.first, as: @editor)
    assert_equal 0, @driver.driver_routes.count
  end

  test "not assigning or destroying a driver route as a viewer" do 
    create_list(:route_with_coordinates, 2)

    post admin_driver_routes_path(driver: @driver, route: Route.first, as: @viewer)
    assert_redirected_to admin_drivers_url
    assert_equal "Unauthorized. Editor or Administrator access is required.", flash[:notice] 

    @driver.driver_routes.create(route: Route.first)
    assert_equal 1, @driver.driver_routes.count
    delete admin_driver_route_path(@driver.driver_routes.first, as: @viewer)
    assert_redirected_to admin_drivers_url
    assert_equal "Unauthorized. Editor or Administrator access is required.", flash[:notice] 
    assert_equal 1, @driver.driver_routes.count        

  end
end
