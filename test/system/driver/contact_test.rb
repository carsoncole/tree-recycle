require "application_system_test_case"

class Driver::ContactTest < ApplicationSystemTestCase

  test "visiting contact" do
    create_list(:leader_driver, 4)

    visit driver_contacts_path
    assert_selector "h1", text: "Contact"
    assert_selector "#contacts-table"
  end
end
