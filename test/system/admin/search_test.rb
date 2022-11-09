require "application_system_test_case"

class Admin::SearchTest < ApplicationSystemTestCase
  setup do
    @reservation = create(:reservation_with_coordinates)
  end

  test "searching for a reservation" do
    system_test_signin

    fill_in "search", with: @reservation.name[0..3]
    click_on "Search"
    assert_text @reservation.name
  end
end
