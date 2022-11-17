require "application_system_test_case"

class Driver::HomeTest < ApplicationSystemTestCase
  test "visiting all of the driver header links" do
    visit driver_root_path

    within "#driver-navbar" do
      click_on 'Home'
    end
      assert_selector "h1", text: "Welcome Drivers!"

    within "#driver-navbar" do
      click_on 'Routes'
    end
      assert_selector "h1", text: "Routes"

    within "#driver-navbar" do
      click_on 'Drivers'
    end
      assert_selector "h1", text: "Drivers"

    within "#driver-navbar" do
      click_on "Driver"
    end
      assert_selector "h1", text: "Welcome Drivers!"
  end

  test "visiting the driver home page" do
    visit driver_root_path
    assert_selector "h1", text: "Welcome Drivers!"
  end

  test "visting the driver home with auth" do
    setting = create(:setting_with_driver_auth)
    visit driver_root_path
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
