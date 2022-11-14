require "application_system_test_case"

class Driver::RoutesTest < ApplicationSystemTestCase
  test "visiting the driver routes page" do
    visit driver_routes_path
    assert_selector "h1", text: "Routes"
  end

  test "visting a route with zone show page" do
    route= create(:route_with_zone)

    visit driver_routes_path
    click_on route.name
    assert_selector "h1", text: route.name_with_zone
  end

  test "visting a route without zone show page" do
    route= create(:route)

    visit driver_routes_path
    click_on route.name
    assert_selector "h1", text: route.name
  end

  test "visiting a route show page with lots of reservations" do
    route = create(:route_with_zone)
    reservations = create_list(:reservation_with_coordinates, 20, route: route)
    visit driver_route_path(route)
    assert_selector "h1", text: route.name_with_zone
  end
end
