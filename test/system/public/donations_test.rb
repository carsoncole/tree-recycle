require "application_system_test_case"

class DonationsTest < ApplicationSystemTestCase
  test "making a donation without a reservation" do
    visit root_url

    click_on "Donate"
    # assert_selector "h1", text: "Please consider a donation"
    # assert_text "Our service is free, but your donation provides opportunities"
  end


  # test "visiting the index" do
  #   visit donations_url
  #   assert_selector "h1", text: "Donations"
  # end

  # test "should create donation" do
  #   visit donations_url
  #   click_on "New donation"

  #   fill_in "New", with: @donation.new
  #   click_on "Create Donation"

  #   assert_text "Donation was successfully created"
  #   click_on "Back"
  # end

  # test "should update Donation" do
  #   visit donation_url(@donation)
  #   click_on "Edit this donation", match: :first

  #   fill_in "New", with: @donation.new
  #   click_on "Update Donation"

  #   assert_text "Donation was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Donation" do
  #   visit donation_url(@donation)
  #   click_on "Destroy this donation", match: :first

  #   assert_text "Donation was successfully destroyed"
  # end
end
