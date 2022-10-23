require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  setup do
    @reservation = create(:reservation)
  end

  test "creating a reservation" do
    visit root_url
    click_on "Make a Tree pickup reservation"

    fill_in "Name", with: @reservation.name
    fill_in "Street", with: @reservation.street
    click_on "Save"

    fill_in "Email", with: @reservation.email
    fill_in "Phone", with: @reservation.phone
    click_on "Save"
  end

  # test "visiting the index" do
  #   visit reservations_url
  #   assert_selector "h1", text: "Reservations"
  # end

  # test "should create reservation" do
  #   visit reservations_url
  #   click_on "New reservation"

  #   fill_in "City", with: @reservation.city
  #   fill_in "Country", with: @reservation.country
  #   fill_in "Email", with: @reservation.email
  #   fill_in "Latitude", with: @reservation.latitude
  #   fill_in "Longitude", with: @reservation.longitude
  #   fill_in "Name", with: @reservation.name
  #   fill_in "Phone", with: @reservation.phone
  #   fill_in "State", with: @reservation.state
  #   fill_in "Street", with: @reservation.street
  #   fill_in "Zip", with: @reservation.zip
  #   click_on "Create Reservation"

  #   assert_text "Reservation was successfully created"
  #   click_on "Back"
  # end

  # test "should update Reservation" do
  #   visit reservation_url(@reservation)
  #   click_on "Edit this reservation", match: :first

  #   fill_in "City", with: @reservation.city
  #   fill_in "Country", with: @reservation.country
  #   fill_in "Email", with: @reservation.email
  #   fill_in "Latitude", with: @reservation.latitude
  #   fill_in "Longitude", with: @reservation.longitude
  #   fill_in "Name", with: @reservation.name
  #   fill_in "Phone", with: @reservation.phone
  #   fill_in "State", with: @reservation.state
  #   fill_in "Street", with: @reservation.street
  #   fill_in "Zip", with: @reservation.zip
  #   click_on "Update Reservation"

  #   assert_text "Reservation was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Reservation" do
  #   visit reservation_url(@reservation)
  #   click_on "Destroy this reservation", match: :first

  #   assert_text "Reservation was successfully destroyed"
  # end
end
