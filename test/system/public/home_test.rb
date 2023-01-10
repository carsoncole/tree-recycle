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

  test "visiting the home page with remind mes enabled" do
    visit root_url
    setting.update(is_remind_mes_enabled: true)

    visit root_url
    within "#remind-me" do
      assert_text "Sign up for our email reminder"
    end

    email = Faker::Internet.email
    fill_in "Name", with: Faker::Name.name
    fill_in "Email", with: email
    click_on "Remind me"

    within "#remind-me-success" do
      assert_selector "h1", text: "We will send you a reminder"
      assert_text email

      click_on "Tree Recycle"
    end
  end

end


