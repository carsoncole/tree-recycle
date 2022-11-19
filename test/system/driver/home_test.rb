require "application_system_test_case"

class Driver::HomeTest < ApplicationSystemTestCase
  test "visiting all of the driver nav links" do
    visit driver_root_path

    within "#driver-nav" do
      click_on 'Routes'
    end
      assert_selector "h1", text: "Routes"

    within "#driver-nav" do
      click_on 'Drivers'
    end
      assert_selector "h1", text: "Drivers"
  end

  test "visting the driver home with auth" do
    setting_generate_driver_secret_key!
    visit driver_root_path
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
