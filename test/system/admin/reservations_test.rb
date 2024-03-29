require "application_system_test_case"

class Admin::ReservationsTest < ApplicationSystemTestCase
  setup do
    @reservation = create(:reservation_with_coordinates, is_routed: false)
  end

  test "visiting the index and viewing various statuses" do
    system_test_signin(:editor)

    visit admin_reservations_path
    within "#status-menu" do
      click_on "Pending pickup"
      click_on "Picked up"
      click_on "Missing"
      click_on "Cancelled"
      click_on "Unconfirmed"
      click_on "Archived"
      click_on "Un-Routed"
      click_on "Manually Geocoded"
      click_on "Manually Routed"
      click_on "Not Polygon Routed"
      click_on "Duplicates"
    end
  end

  test "show basic" do
    system_test_signin(:editor)

    visit admin_reservation_path(@reservation)
    assert_selector "h1", text: @reservation.street
    assert_selector "h3", text: "Address"
    assert_selector "h3", text: "Contact"
    assert_selector "h3", text: "Routing"
  end

  test "editing a reservation" do
    system_test_signin(:editor)
    visit admin_reservation_path(@reservation)
    click_on 'Edit'
    fill_in 'Phone', with: '2065551212'
    fill_in 'Notes', with: 'Customer called and said they moved the tree to the driveway'
    click_on 'Save'

    within '#reservation' do
      assert_text 'Customer called and said they moved the tree to the driveway'
    end

    within '#contact-details' do
      assert_text '2065551212'
    end
  end

  test "changing status to missing" do
    system_test_signin(:editor)
    visit admin_reservation_path(@reservation)

    within '#reservation-status' do
      assert_text 'PENDING PICKUP'
    end

    within '#status' do
      select 'Missing', from: 'reservation-status-dropdown'
      click_on 'Update status'
    end

    within '#reservation-status' do
      assert_text 'MISSING'
    end

    click_on 'View Log'
    within '#reservation-log' do
      assert_text 'Pickup attempted. Tree not found.'
    end
  end

  test "changing status to picked_up" do
    system_test_signin(:editor)
    visit admin_reservation_path(@reservation)

    within '#status' do
      select 'Picked Up', from: 'reservation-status-dropdown'
      click_on 'Update status'
    end

    within '#reservation-status' do
      assert_text 'PICKED UP'
    end

    click_on 'View Log'
    within '#reservation-log' do
      assert_text 'Tree picked up'
    end
  end

  test "changed status to cancelled" do
    system_test_signin(:editor)
    visit admin_reservation_path(@reservation)

    within '#status' do
      select 'Cancelled', from: 'reservation-status-dropdown'
      click_on 'Update status'
    end

    within '#reservation-status' do
      assert_text 'CANCELLED'
    end

    click_on 'View Log'
    within '#reservation-log' do
      assert_text 'Reservation cancelled'
    end
  end

  test "changing reservation route" do
    system_test_signin(:editor)
    create_list(:route, 3)

    visit admin_reservation_path(@reservation)
    assert_selector '#route-name', text: ''

    click_on 'Edit'
    select Route.first.name, from: 'route-dropdown'
    click_on 'Save'

    assert_selector '#route-name', text: Route.first.name
  end

  test "reservations not being open yet" do
    Setting.first_or_create.update(is_reservations_open: false, reservations_closed_message: 'Reservations are CLOSED.')
    visit '/'
    assert_no_link "Reserve now"
    assert_text "Reservations are CLOSED."
  end
end
