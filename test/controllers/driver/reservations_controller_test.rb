require "test_helper"

class Driver::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get map" do
    route = create(:route)
    get driver_reservations_map_url(route_id: route.id)
    assert_response :success
  end

  test "should get search" do
    reservation_1 = create(:reservation_with_coordinates, name: 'Joe Blow', street: '123 Main Street')

    reservation_2 = create(:reservation_with_coordinates, name: 'Mary Blow', street: '123 Main Street')

    reservation_3 = create(:reservation_with_coordinates, name: 'Sam Main', street: '456 Wachner Ave')

    get driver_reservations_search_url
    assert_response :success

    get driver_reservations_search_url, params: { search: 'blow' }

    assert_select "tr", count: 2
    assert "Blow", count: 2

    get driver_reservations_search_url, params: { search: 'main' }

    assert_select "tr", count: 3
    assert "Sam Main"
    assert "Joe Blow"
  end

  test "should get search with auth" do
    get driver_reservations_search_url
    assert_response :success
  end

  test "should get show" do
    reservation = create(:reservation_with_coordinates)

    get driver_reservation_url(reservation)
    assert_response :success
    assert_select "h1", reservation.street
  end

  test "should get show with auth" do
    setting_generate_driver_secret_key!
    reservation = create(:reservation_with_coordinates)

    get driver_reservation_url(reservation)
    assert_redirected_to sign_in_path

    get driver_reservation_url(reservation, key: setting.driver_secret_key)
    assert_response :success
    assert_select "h1", reservation.street
  end

  test "mapping with reservation" do
    reservation = create(:reservation_with_coordinates)
    get driver_reservations_map_path(reservation_id: reservation.id)
    assert_response :success
    assert_select '#map-title', reservation.street
  end

  test "mapping with route" do
    route = create(:route)
    reservation = create(:reservation_with_coordinates, route_id: route.id)
    get driver_reservations_map_path(route_id: route.id)
    assert_response :success
    assert_select '#map-title', route.name_with_zone
  end

  test "mapping with zone" do
    zone = create(:zone)
    route = create(:route, zone_id: zone.id)
    reservation = create(:reservation_with_coordinates, route_id: route.id)
    get driver_reservations_map_path(zone_id: zone.id)
    assert_response :success
    assert_select '#map-title', zone.name
  end

  test "mapping with all" do
    get driver_reservations_map_path
    assert_response :success
  end
end
