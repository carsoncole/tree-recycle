require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  test "creating a valid minimal reservation with good address" do
    visit root_url
    click_on "Make a Tree pickup reservation"

    assert_selector "h1", text: "Tree pickup reservation"
    fill_in "reservation_name", with: reservations(:good_address).name
    fill_in "reservation_street", with: reservations(:good_address).street
    fill_in "reservation_email", with: reservations(:good_address).email
    click_on "Register your address"

    assert_selector "h1", text: "Please consider a donation"
    assert_selector "h5", text: "Donate online"
    assert_selector "h5", text: "Donate at pick-up"
    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  test "creating a valid reservation with all info" do
    visit root_url
    click_on "Make a Tree pickup reservation"

    assert_selector "h1", text: "Tree pickup reservation"
    fill_in "reservation_name", with: reservations(:two).name
    fill_in "reservation_street", with: reservations(:two).street
    fill_in "reservation_email", with: reservations(:two).email
    fill_in "reservation_phone", with: reservations(:two).phone
    fill_in "reservation_notes", with: reservations(:two).notes
    click_on "Register your address"

    assert_selector "h1", text: "Please consider a donation"
    assert_selector "h5", text: "Donate online"
    assert_selector "h5", text: "Donate at pick-up"
    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  test "creating an invalid unknown street reservation with all info" do
    visit root_url
    click_on "Make a Tree pickup reservation"

    assert_selector "h1", text: "Tree pickup reservation"
    fill_in "reservation_name", with: reservations(:invalid_unknown_street).name
    fill_in "reservation_street", with: reservations(:invalid_unknown_street).street
    fill_in "reservation_email", with: reservations(:invalid_unknown_street).email
    click_on "Register your address"
    sleep 2

    assert_text "We are having trouble figuring out your address."
    click_on "Register your address"

    assert_text "Reservation was successfully updated and is confirmed for pick up."
    assert_selector "h1", text: "Please consider a donation"

    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  test "creating a reservation that has a better address" do
    visit root_url
    click_on "Make a Tree pickup reservation"

    assert_selector "h1", text: "Tree pickup reservation"
    fill_in "reservation_name", with: reservations(:better_address_found).name
    fill_in "reservation_street", with: reservations(:better_address_found).street
    fill_in "reservation_email", with: reservations(:better_address_found).email
    click_on "Register your address"

    sleep 2

    assert_text "We are having trouble figuring out your address."
    click_on "Use this corrected address"

    assert_text "Reservation was successfully updated and is confirmed for pick up."
    assert_selector "h1", text: "Please consider a donation"

    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
    assert_text "1760 SUSAN PL NW, Bainbridge Island, Washington"
  end

  test "reservations are closed" do
    visit root_url
    click_on "Make a reservation"
    assert_text "Provide the address where the tree will be located and any helpful notes"

    Setting.first.update(is_reservations_open: false)

    click_on "Make a reservation"
    within("#flash") do
      assert_text "Reservations are CLOSED."
      click_on "Contact us"
    end
    assert_selector 'h1', text: 'Have a question?'
  end

  test "reservations are no longer editable" do
    visit reservation_url(reservations(:good_address))
    click_on 'Edit'
    assert_selector 'h1', text: 'Editing reservation'

    Setting.first.update(is_reservations_open: false)

    visit reservation_url(reservations(:good_address))
    click_on 'Edit'
    within("#flash") do
      assert_text "Reservations are no longer changeable."
      click_on "Contact us"
    end
    assert_selector 'h1', text: 'Have a question?'
  end

  test "reservations are no longer cancelable" do
    visit reservation_url(reservations(:good_address))
    Setting.first.update(is_reservations_open: false)
    click_on "Cancel"
    within("#flash") do
      assert_text "Reservations are no longer changeable."
      click_on "Contact us"
    end
    assert_selector 'h1', text: 'Have a question?'
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
