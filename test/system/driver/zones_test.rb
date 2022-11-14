require "application_system_test_case"

class Driver::ZonesTest < ApplicationSystemTestCase
  test "visiting the driver zones page" do
    visit driver_zones_path
    assert_selector "h1", text: "Zones"
  end

  test "visting a zone show page" do
    zone = create(:zone)
    visit driver_zones_path
    click_on zone.name
    assert_selector "h1", text: zone.name
  end
end
