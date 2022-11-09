require "application_system_test_case"

class Driver::ZoneTest < ApplicationSystemTestCase
  test "visiting the driver zone page" do
    visit '/driver'
    within "#main-navbar" do
      click_on 'Zones'
    end
    assert_selector "h1", text: "Zones"
  end
end
