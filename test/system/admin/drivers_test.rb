require "application_system_test_case"

class Admin::DriversTest < ApplicationSystemTestCase
  setup do
    @driver = create(:driver)
  end

  test "visiting the index" do
    system_test_signin(:editor)
    visit admin_drivers_url
    assert_selector "h1", text: "Drivers"
  end

  test "should create driver" do
    system_test_signin(:editor)
    visit admin_drivers_url
    within "#drivers" do 
      click_on "Driver", match: :first
    end

    fill_in "Name", with: "Joe Blow"
    fill_in "Email", with: "joe@example.com"
    fill_in "Phone", with: '206-555-1212'
    click_on "Save"

    within "#flash" do 
      assert_text "Driver was successfully created."
    end
  end

  test "should update Driver" do
    system_test_signin(:editor)
    visit admin_driver_url(@driver)
    click_on "Edit", match: :first
    fill_in "Phone", with: '800-555-1212'

    click_on "Save"

    assert_text "Driver was successfully updated"
    assert_text "800-555-1212"
  end

  test "should destroy Driver" do
    system_test_signin(:editor)
    visit admin_driver_url(@driver)
    accept_confirm do 
      click_on "Destroy Driver"
    end

    assert_text "Driver was successfully destroyed"
  end
end
