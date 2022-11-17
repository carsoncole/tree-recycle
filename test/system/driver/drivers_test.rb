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

  test "visiting the drivers page with auth" do
    setting = create(:setting_with_driver_auth)
    visit driver_drivers_path
    assert_selector "h1", text: "Sign in"

    visit driver_root_path(params: { key: setting.driver_secret_key })
    assert_selector "h1", text: "Welcome Drivers!"

    # check that param is no longer needed since key is cookie-stored
    visit driver_root_path
    assert_selector "h1", text: "Welcome Drivers!"

    # change of key unvalidates existing key
    setting.update(driver_secret_key: 'Faker::Internet.password')
    visit driver_root_path
    assert_selector "h1", text: "Sign in"

    visit driver_root_path(params: { key: setting.driver_secret_key } )
    assert_selector "h1", text: "Welcome Drivers!"
  end
end
