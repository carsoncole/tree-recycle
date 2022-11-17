require "application_system_test_case"

class Driver::RoutesTest < ApplicationSystemTestCase
  test "visiting the driver home page and check totals" do
    create_list(:reservation_with_coordinates, 13, is_routed: false)
    visit driver_root_path
    assert_selector "h1", text: "Welcome Drivers!"
    assert_text "We have 13 trees to pick up and so far we've picked up 0 trees."
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
      assert_selector ".route-zone", text: zones[1].name.upcase
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

  test "visiting a route page with lots of reservations" do
    route = create(:route_with_zone)
    reservations = create_list(:reservation_with_coordinates, 20, route: route)
    visit driver_route_path(route)
    assert_selector "h1", text: route.name_with_zone
    assert_selector "tr", count: 21
  end

  test "visting a route page and clicking pickups" do
    zone = create(:zone)
    route = create(:route_with_coordinates, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20)

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
    route = create(:route_with_coordinates, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20)

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
    route = create(:route_with_coordinates, zone_id: zone.id)
    reservations = create_list(:reservation_with_coordinates, 20)

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

  test "visiting the driver routes page with auth" do
    setting = create(:setting_with_driver_auth)
    visit driver_routing_path
    assert_selector "h1", text: "Sign in"

    visit driver_routing_path(params: { key: setting.driver_secret_key })
    assert_selector "h1", text: "Routes"

    # check that param is no longer needed since key is cookie-stored
    visit driver_routing_path
    assert_selector "h1", text: "Routes"

    # change of key unvalidates existing key
    setting.update(driver_secret_key: 'Faker::Internet.password')
    visit driver_routing_path
    assert_selector "h1", text: "Sign in"

    visit driver_routing_path(params: { key: setting.driver_secret_key } )
    assert_selector "h1", text: "Routes"
  end
end
