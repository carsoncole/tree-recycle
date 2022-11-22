require "application_system_test_case"

class Driver::SearchTest < ApplicationSystemTestCase

  test "visiting search" do
    visit driver_search_path
    assert_selector "h1", text: "Search"
    assert_selector "#search-form"
  end

  test "search" do
    reservations = create_list(:reservation_with_no_routing, 10)

    visit driver_root_path
    click_on "Search"
    within "#search-form" do
      fill_in "Search", with: reservations[3].name
      click_on "Search"
    end

    assert_selector "#search-results"
    assert_selector "td.name", text: reservations[3].name

    click_on reservations[3].name
    assert_selector 'h1', text: reservations[3].street
  end
end
