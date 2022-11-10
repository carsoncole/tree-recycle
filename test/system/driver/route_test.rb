require "application_system_test_case"

class Driver::RoutesTest < ApplicationSystemTestCase
  test "visiting the driver route page" do
    visit '/driver'
    within "#main-navbar" do
      click_on 'Routes'
    end
    assert_selector "h1", text: "Routes"
  end
end
