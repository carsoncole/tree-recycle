require "application_system_test_case"

class Driver::DriversTest < ApplicationSystemTestCase
  test "visiting the drivers page" do
    visit driver_drivers_path
    assert_selector "h1", text: "Drivers"
  end

  test "visting a driver show page" do
    driver = create(:driver)
    visit driver_drivers_path
    click_on driver.name
    assert_selector "h1", text: driver.name
  end
end
