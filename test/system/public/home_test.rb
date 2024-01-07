require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase

  test "visiting home about and questions" do
    visit root_url
    assert_no_selector "#admin-nav-links"

    has_link? "reservation-button"

    click_on "About"
    assert_selector "h1", text: "Tree pickup details"
    assert_no_selector "#admin-nav-links"

    click_on "question_header_link"
    assert_selector "h1", text: "Have a question?"
    assert_no_selector "#admin-nav-links"
  end

  test "visiting the home page with reservations closed" do
    visit root_url
    setting.update(is_reservations_open: false, reservations_closed_message: 'We are closed')

    visit root_url
    assert_selector "#flash", text: "We are closed"

    assert_no_link "reservation-button"

    within "#main-navbar" do
      click_on "New reservation"
    end

    assert_selector "#flash", text: "We are closed"
  end
end


