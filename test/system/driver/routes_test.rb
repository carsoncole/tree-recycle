require "application_system_test_case"

#TODO add more tests on routing page on calcs and 'No Zone'
class Driver::RoutesTest < ApplicationSystemTestCase

  test "visiting the driver root path and nav links" do
    visit driver_root_path
    assert_selector "h1", text: "Routes"

    click_on 'Drivers'
    assert_selector "h1", text: "Drivers"

    click_on 'Search'
    assert_selector "h1", text: "Search"

    click_on 'Routes'
    assert_selector "h1", text: "Routes"
  end

  test "visiting driver links with auth, and changing key" do
    setting_generate_driver_secret_key!

    visit driver_root_path
    assert_selector "h1", text: "Sign in"

    visit driver_root_path(key: setting.driver_secret_key)
    assert_selector "h1", text: "Routes"

    click_on 'Drivers'
    assert_selector "h1", text: "Drivers"

    click_on 'Search'
    assert_selector "h1", text: "Search"

    click_on 'Routes'
    assert_selector "h1", text: "Routes"

    setting.update(driver_secret_key: 'newkey')

    click_on 'Drivers'
    assert_selector "h1", text: "Sign in"

    visit '/driver/search?key=newkey'
    assert_selector "h1", text: "Search"

    click_on 'Routes'
    assert_selector "h1", text: "Routes"
  end

  test "routes page content" do
    visit driver_routing_path
    assert_selector "h1", text: "Routes"

    within "#all-zones" do
      assert_selector "tbody tr", count: 1 # row 'ALL'
      assert_selector "th.zone", text: 'ALL'
      assert_selector "#all-map-link"
      assert_selector "#all-pending-count", text: '0'
      assert_selector "#all-missing-count", text: '0'
      assert_selector "#all-picked-count", text: '0'
    end

    # create 5 reservations in a zoned route (ZONE, ROUTE name)
    # create 3 reservation in unzoned route
    # create 2 reservations that are unrouted (UNROUTED)
    # ALL row, Blank row
    route = create(:route_with_zone)
    route_without_zone = create(:route, is_zoned: false)
    reservations = create_list(:reservation_with_coordinates, 5, route_id: route.id)
    reservations_without_routed_zones = create_list(:reservation_with_coordinates, 3, is_routed: false, route: route_without_zone)
    reservations_without_routes = create_list(:reservation_with_coordinates, 2, is_routed: false)

    click_on 'Routes'
    within "#zone-#{ route.zone.id }" do
      assert_selector "tbody tr", count: 2
      assert_selector "th.zone", text: route.zone.name.upcase
      assert_selector "th.route", text: route.name
      assert_selector "#route-pending-pickup-count", text: '5'
    end
  end

  test "visting a route page and clicking pickups" do
    zone = create(:zone)
    route = create(:route, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20, route: route)

    assert_equal 20, Reservation.pending_pickup.count

    visit driver_route_path(route)
    assert_selector "#btn-picked-up-#{reservations[0].id}"
    assert_selector "#btn-picked-up-#{reservations[1].id}"
    assert_selector "#btn-picked-up-#{reservations[2].id}"

    accept_confirm do
      click_on "btn-picked-up-#{reservations[0].id}"
    end
    assert_no_selector "#btn-picked-up-#{reservations[0].id}"
    assert_selector "#btn-not-picked-up-#{reservations[0].id}"

    visit driver_routing_path
    assert_selector "#all-pending-count", text: '19'
    assert_selector "#all-picked-count", text: '1'
  end

  test "visting a route page and clicking missing" do
    zone = create(:zone)
    route = create(:route, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20, route_id: route.id)

    visit driver_route_path(route)

    accept_confirm do
      click_on "btn-missing-#{reservations[0].id}"
    end
    assert_no_selector "#btn-missing-#{reservations[0].id}"

    visit driver_routing_path
    assert_selector "#all-pending-count", text: '19'
    assert_selector "#all-picked-count", text: '0'
    assert_selector "#all-missing-count", text: '1'
  end

  test "visting a route page and pending pickup" do
    zone = create(:zone)
    route = create(:route, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20, route_id: route.id)

    visit driver_route_path(route)

    accept_confirm do
      click_on "btn-missing-#{reservations[0].id}"
      sleep 0.25
    end
    accept_confirm do
      click_on "btn-missing-#{reservations[1].id}"
      sleep 0.25
    end

    visit driver_routing_path
    assert_selector "#all-missing-count", text: '2'

    visit driver_route_path(route)

    assert_no_selector "#btn-not-pending-pickup-#{reservations[0].id}"
    assert_no_selector "#btn-not-pending-pickup-#{reservations[1].id}"

    accept_confirm do
      click_on "btn-pending-pickup-#{reservations[0].id}"
    end
    accept_confirm do
      click_on "btn-picked-up-#{reservations[1].id}"
    end

    visit driver_routing_path
    assert_selector "#all-missing-count", text: '0'
    assert_selector "#all-pending-count", text: '19'
    assert_selector "#all-picked-count", text: '1'
  end
end
