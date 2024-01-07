require "application_system_test_case"

class Admin::OperationsTest < ApplicationSystemTestCase
  test "post event archive" do 
    create_list(:archived_reservation, 30)
    create_list(:reservation_picked_up, 20)

    system_test_signin(:administrator)

    visit admin_operations_path
    accept_confirm do
      click_button "ARCHIVE ALL"
    end

    within "#flash" do
      assert_text 'All Reservation data has been archived.'
    end
  end
end
