require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  test "viewing the reservation pages" do 
    Setting.destroy_all
    create(:setting)
    reservation = build_stubbed(:reservation)

    visit '/'
    click_on "Reserve now"

    # check side info
    within "#side-info" do
      assert_selector "h1", text: "Summary"
      assert_no_selector "h2", text: "Address"
      assert_selector "h2", text: "Pickup details"
      assert_no_selector "h2", text: "Contact"
      assert_selector "#pickup-date", text: "January 2, 2027"
      assert_selector "#pickup-time", text: "8:00 AM - 2:00 PM"
    end

    # fill out reservation form
    within "#new-reservation" do 
      fill_in "reservation_name", with: reservation.name
      fill_in "reservation_street", with: reservation.street
      fill_in "reservation_email", with: reservation.email
      fill_in "reservation_phone", with: '206-555-1212'
      fill_in "reservation_notes", with: Faker::Lorem.sentences(number: 3).join(" ")
      fill_in "Where will your tree be?", with: 'end of driveway'

      find('#heard-about-sources option', :text => 'Facebook').click
      select 'Word Of Mouth', from: 'heard-about-sources'

      # register
      click_on "Register your address"
    end

    # review summery of reservation
    within "#side-info" do
      assert_selector "h1", text: "Summary"
      assert_selector "h2", text: "Address"
      assert_selector "h2", text: "Pickup details"
      assert_selector "h2", text: "Contact"

      assert_selector ".street", text: reservation.street
      assert_selector ".email", text: reservation.email
    end

    # view the donation option buttons
    within '#donation' do 
      assert_button "Donate online"
      assert_button "Donate at pick-up"
      assert_button "No donation"
    end

    # Choose 'No donation'
    click_on 'No donation'
    sleep 0.25
    assert_selector 'h1', text: 'Tree Pickup'
    assert_selector '.important-message', text: 'This reservation is scheduled for pickup.'

    # go back to the donate page
    within '#reservation' do 
      click_on 'Donate'
    end
    assert_selector 'h1', text: 'Please consider a donation'

    # choose 'Donate at pickup'
    click_on 'Donate at pick-up'
    assert_selector 'h1', text: 'Tree Pickup'
    assert_selector '#flash', text: 'Your tree pick-up is confirmed. You can leave your donation with your tree.'

    # check underlying data
    assert submitted_reservation = Reservation.find_by_email(reservation.email)
    assert submitted_reservation.pending_pickup?
    assert_equal reservation.street, submitted_reservation.street
    assert 'end of driveway', submitted_reservation.notes
    assert submitted_reservation.word_of_mouth?
    assert submitted_reservation.cash_or_check_donation?

  end

  test "creating a valid minimal reservation with good address and online donation" do
    reservation = build_stubbed(:reservation)

    visit root_url
    click_on "Reserve now"

    fill_in "reservation_name", with: reservation.name
    fill_in "reservation_street", with: reservation.street
    fill_in "reservation_email", with: reservation.email
    select 'Roadside Sign', from: 'heard-about-sources'

    click_on "Register your address"
    sleep 1

    click_on "Donate at pick-up"
  end

  test "creating an invalid unknown street reservation with all info" do
    reservation = build(:reservation)

    visit root_url
    click_on "Reserve now"

    fill_in "reservation_name", with: reservation.name
    fill_in "reservation_street", with: 'gobbly gook'
    fill_in "reservation_email", with: reservation.email
    select 'Christmas Tree Lot Flyer', from: 'heard-about-sources'
    click_on "Register your address"
    sleep 1

    assert_text "Ouch! We are having issues and"
    click_on "Register your address"
    sleep 1
    assert_text "Reservation was successfully updated and is confirmed for pick up."
    assert_selector "h1", text: "Please consider a donation"

    click_on "Donate at pick-up"
    assert_text "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  test "creating a reservation that has a better address" do
    visit root_url
    click_on "Reserve now"

    fill_in "reservation_name", with: 'John Doe'
    fill_in "reservation_street", with: '1760 su san pl'
    fill_in "reservation_email", with: 'john@example.com'
    click_on "Register your address"

    sleep 3

    assert_text "Ouch! We are having issues and"
    click_on "Use this corrected address"
    sleep 1

    assert_text "Reservation was successfully updated and is confirmed for pick up."
    assert_selector "h1", text: "Please consider a donation"

    click_on "No donation"

    assert_selector "h1", text: "Tree Pickup"
  end

  test "reservations are closed" do
    Setting.first_or_create.update(is_reservations_open: false)

    visit '/'
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
