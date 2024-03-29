require "test_helper"

class Admin::ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = create(:reservation_with_coordinates, status: :pending_pickup, is_routed: false)
    @archived_reservation = create(:reservation_with_coordinates, status: 'archived', is_routed: false)
    @viewer = create :viewer
    @editor = create :editor
    @administrator = create :administrator
  end

  test "should get index" do
    get admin_reservations_url(as: @viewer)
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

    get admin_reservations_url(route_id: reservation_routed.route_id, as: @viewer)
    assert_match reservation_routed.name.split(/ /)[0], @response.body

    get admin_reservations_url(picked_up: true, as: @viewer)
    assert_match reservation_picked_up.name.split(/ /)[0], @response.body 

    get admin_reservations_url(cancelled: true, as: @viewer)
    assert_match reservation_cancelled.name.split(/ /)[0], @response.body

    get admin_reservations_url(missing: true, as: @viewer)
    assert_match reservation_missing.name.split(/ /)[0], @response.body

    get admin_reservations_url(archived: true, as: @viewer)
    assert_match reservation_archived.name.split(/ /)[0], @response.body

    get admin_reservations_url(all: true, as: @viewer)
    assert_match reservation_missing.name.split(/ /)[0], @response.body

    get admin_reservations_url(unrouted: true, as: @viewer)
    assert_match @reservation.name.split(/ /)[0], @response.body
  end

  test "should get show with auth" do
    get admin_reservation_url(@reservation, as: @viewer)
    assert_response :success
  end

  test "should not get show without auth" do
    get admin_reservation_url(@reservation)
    assert_redirected_to sign_in_path
  end

  test "show reservation" do 
    get admin_reservation_url(@reservation)
    assert_redirected_to  sign_in_path

    get admin_reservation_url(@reservation, as: @viewer)
    assert_response :success
  end

  test "should update reservation" do
    patch admin_reservation_url(@reservation, as: @editor), params: { reservation: { name: 'Name updated' } }
    assert_redirected_to admin_reservation_url(@reservation)
  end

  test "should not update reservation as viewer" do
    patch admin_reservation_url(@reservation, as: @viewer), params: { reservation: { name: 'Name updated' } }
    assert_response :unauthorized
  end

  test "should destroy reservation" do
    assert_difference("Reservation.pending_pickup.count", -1) do
      delete admin_reservation_url(@reservation, as: @administrator)
    end

    assert_redirected_to admin_reservations_url
  end

  test "should not destroy reservation as editor" do
    assert_difference("Reservation.pending_pickup.count", 0) do
      delete admin_reservation_url(@reservation, as: @editor)
    end

    assert_response :unauthorized
  end

  test "should not destroy reservation as viewer" do
    assert_difference("Reservation.pending_pickup.count", 0) do
      delete admin_reservation_url(@reservation, as: @viewer)
    end
    assert_response :unauthorized
  end

  test "archiving as editor or administrator" do 
    post admin_reservation_archive_path(@reservation, as: @editor)
    assert @reservation.reload.archived?

    @reservation.unconfirmed!

    post admin_reservation_archive_path(@reservation, as: @editor)
    assert @reservation.reload.archived?
  end

  test "archiving as editor" do 
    post admin_reservation_archive_path(@reservation, as: @editor)
    assert @reservation.reload.archived?
  end

  test "not archiving as viewer" do 
    post admin_reservation_archive_path(@reservation, as: @viewer)
    assert_not @reservation.reload.archived?
  end


  test "should destroy reservation as admin, with reservations closed" do 
    Setting.first_or_create.update(is_reservations_open: false)
    new_reservation = create(:reservation_with_coordinates, is_routed: false, status: :pending_pickup)

    assert_difference("Reservation.count", -1) do # reservations are still changeable for admin
      delete admin_reservation_url(new_reservation, as: @administrator)
    end

    assert_redirected_to admin_reservations_url
  end

  test "mapping of a route and all" do 
    route = create(:route, is_zoned: false)

    get admin_map_path(route_id: route.id, as: @viewer)
    assert_response :success

    get admin_map_path(as: @viewer)
    assert_response :success
  end

  test "reservations search" do 
    get admin_search_url(search: @reservation.name, as: @viewer)
    assert_response :success
    assert @response.body.include? @reservation.name
  end

  test "reservations search in the archive" do
    get admin_search_url(search: @archived_reservation.name + ' in:archive', as: @viewer)
    assert_response :success
    assert @response.body.include? @archived_reservation.name
  end

  test "routing a reservation" do 
    route = create(:route_with_coordinates, is_zoned: false)
    @reservation.update(is_routed: true) 
    assert_not @reservation.route

    post admin_reservation_process_route_path(@reservation, as: @editor)
    assert_redirected_to admin_reservations_path
    @reservation.reload
    assert @reservation.route
  end

  test "not routing a reservation as viewer" do 
    route = create(:route_with_coordinates, is_zoned: false)
    @reservation.update(is_routed: true) 
    assert_not @reservation.route

    post admin_reservation_process_route_path(@reservation, as: @viewer)
    assert_response :unauthorized
  end

  test "routing all reservations" do
    create(:route_with_coordinates, is_zoned: false)
    @reservation.update(is_routed: true) 
    assert_not @reservation.route

    assert_enqueued_jobs(1) do
      post admin_process_all_routes_path(as: @editor)
    end

    assert_redirected_to admin_reservations_path
    sleep 1

    @reservation.route!
    @reservation.save
    @reservation.reload
    assert @reservation.route
  end

  test "not routing all reservations as viewer" do
    create(:route_with_coordinates, is_zoned: false)

    post admin_process_all_routes_path(as: @viewer)
    assert_response :unauthorized
  end

  test "processing all routes" do
    post admin_process_all_routes_path(as: @administrator)
    assert_redirected_to admin_reservations_url

    post admin_process_all_routes_path(as: @editor)
    assert_redirected_to admin_reservations_url

    post admin_process_all_routes_path(as: @viewer)
    assert_response :unauthorized
  end

  test "destroying all reservations" do 
    assert_difference('Reservation.count', -2) do
      delete admin_destroy_all_reservations_path(as: @administrator)
    end
  end

  test "destroying all archived reservations" do 
    assert_difference('Reservation.count', -1) do
      delete admin_destroy_all_archived_reservations_path(as: @administrator)
    end
  end

end
