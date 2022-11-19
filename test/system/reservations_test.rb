require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  test "creating a valid reservation with good address and donation at pick-up" do
    reservation = build_stubbed(:reservation)

    visit root_url
    click_on "Reserve a tree pickup"

    within "#side-info" do
      assert_selector "h1", text: "Tree Reservation"

    end
    within "#new-reservation" do
      assert_selector "h1", text: "New Reservation"
    end
    fill_in "reservation_name", with: reservation.name
    fill_in "reservation_street", with: reservation.street
    fill_in "reservation_email", with: reservation.email
    click_on "Register your address"

    assert_selector "#flash", text: "You are all set! Your pickup reservation is confirmed."

    assert_selector "h1", text: "Please consider a donation"
    assert_selector "h5", text: "Donate online"
    assert_selector "h5", text: "Donate at pick-up"
    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  test "creating a valid minimal reservation with good address and online donation" do
    reservation = build_stubbed(:reservation)

    visit root_url
    click_on "Reserve a tree pickup"

    fill_in "reservation_name", with: reservation.name
    fill_in "reservation_street", with: reservation.street
    fill_in "reservation_email", with: reservation.email
    click_on "Register your address"

    click_on "Donate at pick-up"
  end

  test "creating a valid reservation with all info" do
    reservation = build(:reservation)

    visit root_url
    click_on "Reserve a tree pickup"

    fill_in "reservation_name", with: reservation.name
    fill_in "reservation_street", with: reservation.street
    fill_in "reservation_email", with: reservation.email
    fill_in "reservation_phone", with: reservation.phone
    fill_in "reservation_notes", with: Faker::Lorem.sentences(number: 3).join(" ")
    click_on "Register your address"

    within "#side-info" do
      assert_selector ".full_name", text: reservation.name
      assert_selector ".street", text: reservation.street
      assert_selector ".city", text: reservation.city
      assert_selector ".state", text: reservation.state
      assert_selector ".notes", text: reservation.notes
    end

    assert_selector "h1", text: "Please consider a donation"
    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  test "creating an invalid unknown street reservation with all info" do
    reservation = build(:reservation)

    visit root_url
    click_on "Reserve a tree pickup"

    fill_in "reservation_name", with: reservation.name
    fill_in "reservation_street", with: 'gobbly gook'
    fill_in "reservation_email", with: reservation.email
    click_on "Register your address"
    sleep 1.5

    assert_text "Ouch! We are having issues and"
    sleep 0.5
    click_on "Register your address"

    assert_text "Reservation was successfully updated and is confirmed for pick up."
    assert_selector "h1", text: "Please consider a donation"

    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  test "creating a reservation that has a better address" do
    visit root_url
    click_on "Reserve a tree pickup"

    fill_in "reservation_name", with: 'John Doe'
    fill_in "reservation_street", with: '1760 su san pl'
    fill_in "reservation_email", with: 'john@example.com'
    click_on "Register your address"

    sleep 1.5

    assert_text "Ouch! We are having issues and"
    click_on "Use this corrected address"

    assert_text "Reservation was successfully updated and is confirmed for pick up."
    assert_selector "h1", text: "Please consider a donation"

    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
    assert_text "1760 SUSAN PL NW, Bainbridge Island, Washington"
  end

  test "reservations are closed" do
    visit root_url
    click_on "New reservation"
    assert_text "Provide the address where the tree will be located and any helpful notes"

    Setting.first_or_create.update(is_reservations_open: false)

    click_on "New reservation"
    within("#flash") do
      assert_text "Reservations are CLOSED."
      click_on "Contact us"
    end
    assert_selector 'h1', text: 'Have a question?'
  end

  test "reservations are no longer editable" do
    reservation = create(:reservation_with_coordinates)
    visit reservation_url(reservation)
    click_on 'Edit'
    assert_selector 'h1', text: 'Editing reservation'

    Setting.first_or_create.update(is_reservations_open: false)

    visit reservation_url(reservation)
    has_no_link? 'Edit'
  end

  test "reservations are no longer editable when visiting from mail link" do
    reservation = create(:reservation_with_coordinates)
    Setting.first_or_create.update(is_reservations_open: false)

    visit reservation_url(reservation)
    has_no_link? 'Edit'
    assert_text "Reservations are currently closed and not changeable."
  end

  test "reservations are no longer cancellable" do
    reservation = create(:reservation_with_coordinates)
    visit reservation_url(reservation)
    has_link? 'Cancel'

    Setting.first.update(is_reservations_open: false)
    has_no_link? 'Cancel'
  end
end
