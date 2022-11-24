require "test_helper"

class Admin::ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = create(:reservation_with_coordinates, status: :pending_pickup, is_routed: false)
    @user = create :user
  end

  test "should get index" do
    get admin_reservations_url(as: @user)
    assert_response :success
  end

  test "should not get index without auth" do
    get admin_reservations_url
    assert_redirected_to sign_in_path
  end

  test "should get index, filtered" do
    route = create(:route_with_coordinates, is_zoned: false)
    reservation_routed = create(:reservation_with_coordinates, route: route)
    reservation_picked_up = create(:reservation_with_coordinates, status: :picked_up, is_routed: false)
    reservation_cancelled = create(:reservation_with_coordinates, status: :cancelled, is_routed: false)
    reservation_missing = create(:reservation_with_coordinates, status: :missing, is_routed: false)
    reservation_archived = create(:reservation_with_coordinates, status: :archived, is_routed: false)

    get admin_reservations_url(route_id: reservation_routed.route_id, as: @user)
    assert @response.body.include? reservation_routed.name

    get admin_reservations_url(picked_up: true, as: @user)
    assert @response.body.include? reservation_picked_up.name 

    get admin_reservations_url(cancelled: true, as: @user)
    assert @response.body.include? reservation_cancelled.name

    get admin_reservations_url(missing: true, as: @user)
    assert @response.body.include? reservation_missing.name

    get admin_reservations_url(archived: true, as: @user)
    assert @response.body.include? reservation_archived.name

    get admin_reservations_url(all: true, as: @user)
    assert @response.body.include? reservation_missing.name

    get admin_reservations_url(unrouted: true, as: @user)
    assert @response.body.include? @reservation.name
  end

  test "should get show with auth" do
    get admin_reservation_url(@reservation, as: @user)
    assert_response :success
  end

  test "should not get show without auth" do
    get admin_reservation_url(@reservation)
    assert_redirected_to sign_in_path
  end

  test "show reservation" do 
    get admin_reservation_url(@reservation)
    assert_redirected_to  sign_in_path

    get admin_reservation_url(@reservation, as: @user)
    assert_response :success
  end

  test "should update reservation" do
    patch admin_reservation_url(@reservation, as: @user), params: { reservation: { name: 'Name updated' } }
    assert_redirected_to admin_reservation_url(@reservation)
  end

  test "should destroy reservation" do
    assert_difference("Reservation.pending_pickup.count", -1) do
      delete admin_reservation_url(@reservation, as: @user)
    end

    assert_redirected_to admin_root_url

    Setting.first.update(is_reservations_open: false)
    new_reservation = create(:reservation_with_coordinates, is_routed: false, status: :pending_pickup)


    assert_difference("Reservation.pending_pickup.count", -1) do # reservations are still changeable for admin
      delete admin_reservation_url(new_reservation, as: @user)
    end

    assert_redirected_to admin_root_url
  end

  test "mapping of a route and all" do 
    route = create(:route, is_zoned: false)

    get admin_map_path(route_id: route.id, as: @user)
    assert_response :success

    get admin_map_path(as: @user)
    assert_response :success
  end

  #OPTIMIZE this test only verifies a successful response, not successful answers
  test "reservations search" do 
    get admin_search_url(search: @reservation.name, as: @user)
    assert_response :success
    assert @response.body.include? @reservation.name
  end

  #OPTIMIZE does not assert actual search results
  test "reservations search in the archive" do 
    get admin_search_url(search: @reservation.name + ' in:archive', as: @user)
    assert_response :success
  end

  test "routing a reservation" do 
    route = create(:route_with_coordinates, is_zoned: false)
    @reservation.update(is_routed: true) 
    assert_not @reservation.route

    post admin_reservation_process_route_path(@reservation, as: @user)
    assert_redirected_to admin_reservations_path
    @reservation.reload
    assert @reservation.route
  end

  test "routing all reservations" do
    create(:route_with_coordinates, is_zoned: false)
    @reservation.update(is_routed: true) 
    assert_not @reservation.route

    post admin_process_all_routes_path(as: @user)
    assert_redirected_to admin_reservations_path
    @reservation.reload
    assert @reservation.route
  end

  test "archiving all reservations" do
    create_list(:reservation_with_coordinates, 10, is_routed: false)
    assert_equal 0, Reservation.archived.count
    delete admin_archive_all_path(as: @user)
    assert_equal 11, Reservation.archived.count
  end

end
