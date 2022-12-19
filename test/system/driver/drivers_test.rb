require "application_system_test_case"
#todo test for show
#todo test for map
class Driver::DriversTest < ApplicationSystemTestCase
  test "visiting the drivers page" do
    visit driver_drivers_path
    assert_selector "h1", text: "Drivers"
  end

  test "driver show with all info" do
    driver = create( :driver, email: random_email)
    visit driver_driver_path(driver)
    assert_text driver.email
    assert_text driver.phone
  end

  test "visiting the drivers page with auth" do
    setting_generate_driver_secret_key!
    visit driver_drivers_path
    assert_selector "h1", text: "Sign in"

    visit driver_root_path(params: { key: setting.driver_secret_key })
    assert_selector "h1", text: "Routes"

    # check that param is no longer needed since key is cookie-stored
    visit driver_root_path
    assert_selector "h1", text: "Routes"

    # change of key unvalidates existing key
    setting.update(driver_secret_key: 'Faker::Internet.password')
    visit driver_root_path
    assert_selector "h1", text: "Sign in"

    visit driver_root_path(params: { key: setting.driver_secret_key } )
    assert_selector "h1", text: "Routes"
  end
end
