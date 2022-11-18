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
    assert_select "h1", text: reservation.street
  end

  test "should get show with auth" do
    setting = create(:setting_with_driver_auth)
    reservation = create(:reservation_with_coordinates)

    get driver_reservation_url(reservation)
    assert_redirected_to sign_in_path

    get driver_reservation_url(reservation, key: setting.driver_secret_key)
    assert_response :success
    assert_select "h1", text: reservation.street
  end
end
