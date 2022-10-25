require "application_system_test_case"

class Admin::ReservationsTest < ApplicationSystemTestCase
  setup do
    @reservation = create(:reservation)
  end

  test "searching for a reservation" do
    system_test_signin

    fill_in "search", with: @reservation.name[0..3]
    click_on "Search"
    assert_text @reservation.name
  end

end
