require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase

  test "visiting the home page and about" do
    visit root_url

    click_on "About"
    assert_selector "h1", text: "Tree Pickup"

    click_on "question_header_link"
    assert_selector "h1", text: "Have a question?"
  end

end


