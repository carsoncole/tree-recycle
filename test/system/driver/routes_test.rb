require "application_system_test_case"

#TODO add more tests on routing page on calcs and 'No Zone'
class Driver::RoutesTest < ApplicationSystemTestCase

  test "visiting the driver root path and menu links" do
    visit driver_root_path
    assert_selector "h1", text: "Routes"

    click_on 'Drivers'
    assert_selector "h1", text: "Drivers"

    click_on 'Search'
    assert_selector "h1", text: "Search"

    click_on 'Routes'
    assert_selector "h1", text: "Routes"
  end

  test "visiting the driver root path and menu links with auth" do
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

    setting.update(driver_secret_key: nil)

    click_on 'Drivers'
    assert_selector "h1", text: "Drivers"

    setting.update(driver_secret_key: 'hello')
    visit '/driver/search?key=hello'
    assert_selector "h1", text: "Search"
  end

  test "formatting of the routes page" do
    visit driver_routing_path
    assert_selector "h1", text: "Routes"

    within "#driver-zones-table" do
      assert_selector "tbody tr", count: 1 # row 'ALL'
      assert_selector "th.zone", text: 'ALL'
    end

    route = create(:route_with_zone)
    route_without_zone = create(:route)
    reservations = create_list(:reservation_with_coordinates, 5, route_id: route.id)
    reservations_without_routed_zones = create_list(:reservation_with_coordinates, 3, route_id: route_without_zone)
    reservations_without_routes = create_list(:reservation_with_coordinates, 2, is_routed: false)

    click_on 'Routes'
    within "#driver-zones-table" do
      assert_selector "tbody tr", count: 6
      assert_selector "th.zone", text: route.zone.name.upcase
      assert_selector "th.route", text: route.name
      assert_selector "#route-pending-pickup-count", text: '5'
      assert_selector "th.zone", text: 'UNROUTED'
      assert_selector "#total-unrouted-pending-pickup-count", text: '2'
      assert_selector "#total-no-zone-pending-pickup-count", text: '3'
    end

  end

  test "visting a route page and clicking pickups" do
    zone = create(:zone)
    route = create(:route, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20,route_id: route.id)

    assert_equal 20, Reservation.pending_pickup.count

    visit driver_route_path(route)
    assert_selector "#btn-not-picked-up-#{reservations[0].id}"
    assert_selector "#btn-not-picked-up-#{reservations[1].id}"
    assert_selector "#btn-not-picked-up-#{reservations[2].id}"

    accept_confirm do
      click_button "btn-not-picked-up-#{reservations[0].id}"
    end
    assert_no_selector "#btn-not-picked-up-#{reservations[0].id}"
    assert_selector "#btn-picked-up-#{reservations[0].id}"

    assert_equal 1, Reservation.picked_up.count
    assert_equal 19, Reservation.pending_pickup.count
  end

  test "visting a route page and clicking missing" do
    zone = create(:zone)
    route = create(:route, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20, route_id: route.id)

    visit driver_route_path(route)

    accept_confirm do
      click_button "btn-not-missing-#{reservations[0].id}"
    end
    assert_no_selector "#btn-not-missing-#{reservations[0].id}"

    assert_equal 1, Reservation.missing.count
    assert_equal 19, Reservation.pending_pickup.count
  end

  test "visting a route page and pending pickup" do
    zone = create(:zone)
    route = create(:route, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20, route_id: route.id)

    visit driver_route_path(route)

    accept_confirm do
      click_button "btn-not-missing-#{reservations[0].id}"
    end
    accept_confirm do
      click_button "btn-not-missing-#{reservations[1].id}"
    end
    sleep 0.25
    assert_equal 18, Reservation.pending_pickup.count
    assert_equal 2, Reservation.missing.count

    assert_no_selector "#btn-pending-pickup-#{reservations[0].id}"
    assert_no_selector "#btn-pending-pickup-#{reservations[1].id}"

    accept_confirm do
      click_button "btn-missing-#{reservations[0].id}"
    end
    accept_confirm do
      click_button "btn-missing-#{reservations[1].id}"
    end

    assert_equal 18, Reservation.pending_pickup.count
    assert_equal 2, Reservation.missing.count
  end
end
