require "application_system_test_case"

class Driver::HomeTest < ApplicationSystemTestCase
  test "visiting the driver home page" do
    visit '/driver'
    within "#main-navbar" do
      click_on 'Home'
    end
    assert_selector "h1", text: "Welcome Drivers!"
  end
end
