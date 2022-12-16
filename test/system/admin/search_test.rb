require "application_system_test_case"

class Admin::SearchTest < ApplicationSystemTestCase
  setup do
    @reservation = create(:reservation_with_coordinates)
  end

  test "searching for a reservation" do
    system_test_signin(:editor)

    visit admin_reservations_path
    fill_in "Search", with: @reservation.name[0..3]
    click_on "Search"
    assert_text @reservation.name
  end

  test "searching archive for a reservation" do
    reservation = create(:reservation, name: 'John Wilson Doe', is_routed: false)
    archived_reservation = create(:archived_with_coordinates_reservation, is_routed: false, name: 'Wilbur Hester' )

    system_test_signin(:editor)
    visit admin_reservations_path
    fill_in "search", with: 'Wil'
    click_on "Search"
    assert_selector "tr", count: 2 # includes header, no archived
    assert_selector "td", text: 'John Wilson Doe'

    fill_in "search", with: 'Wil in:archive'
    click_on "Search"
    assert_selector "tr", count: 2 # includes header
    assert_selector "td", text: 'Wilbur Hester'
  end
end

