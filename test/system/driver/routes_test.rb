require "application_system_test_case"

class Driver::RoutesTest < ApplicationSystemTestCase
  test "visiting the driver home page and check totals" do
    create_list(:reservation_with_coordinates, 13, is_routed: false)
    visit driver_root_path
    assert_selector "h1", text: "Welcome Drivers!"


  end

  test "visiting the driver routes page" do
    visit driver_routing_path
    assert_selector "h1", text: "Routes"


    zones = create_list(:zone_with_coordinates, 4)
    routes = []
    zones.each do |zone|
      routes += create_list(:route_with_coordinates, 5, zone_id: zone.id)
    end

    (1..10).each do
      create(:reservation_with_coordinates, distance_to_route: 1, route_id: routes[1].id)
    end

    create_list(:reservation_with_coordinates, 10, is_routed: false)

    visit driver_routing_path

    within "#driver-zones" do
      assert_selector "tr", count: 26
      assert_selector ".route-zone", count: 4
      assert_selector ".route-zone", text: zones[1].name
      assert_selector ".route", text: routes[1].name
      assert_selector "#not_archived_#{routes[1].id}", text: "10"
      assert_selector "#not_archived_#{routes[2].id}", text: "0"
      assert_selector "#route-name-#{routes[3].id}", text: routes[3].name
      assert_selector "#total-unrouted-count", text: "10"
      assert_selector ".zone", text: 'UNROUTED'
    end
  end

  test "visting a routing page" do
    route= create(:route_with_zone)
    visit driver_routing_path
    click_on route.name
    assert_selector "h1", text: route.name_with_zone
  end

  test "visiting a route show page with lots of reservations" do
    route = create(:route_with_zone)
    reservations = create_list(:reservation_with_coordinates, 20, route: route)
    visit driver_route_path(route)
    assert_selector "h1", text: route.name_with_zone
  end
end
