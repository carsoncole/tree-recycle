require "application_system_test_case"

class ZonesTest < ApplicationSystemTestCase
  setup do
    @zone = zones(:one)
  end

  test "visiting the index" do
    visit zones_url
    assert_selector "h1", text: "Zones"
  end

  test "should create zone" do
    visit zones_url
    click_on "New zone"

    fill_in "Center address", with: @zone.address
    fill_in "Center city", with: @zone.city
    fill_in "Center state", with: @zone.state
    fill_in "Distance", with: @zone.distance
    fill_in "Name", with: @zone.name
    click_on "Create Zone"

    assert_text "Zone was successfully created"
    click_on "Back"
  end

  test "should update Zone" do
    visit zone_url(@zone)
    click_on "Edit this zone", match: :first

    fill_in "Center address", with: @zone.address
    fill_in "Center city", with: @zone.city
    fill_in "Center state", with: @zone.state
    fill_in "Distance", with: @zone.distance
    fill_in "Name", with: @zone.name
    click_on "Update Zone"

    assert_text "Zone was successfully updated"
    click_on "Back"
  end

  test "should destroy Zone" do
    visit zone_url(@zone)
    click_on "Destroy this zone", match: :first

    assert_text "Zone was successfully destroyed"
  end
end
