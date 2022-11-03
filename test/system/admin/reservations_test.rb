require "application_system_test_case"

class Admin::ReservationsTest < ApplicationSystemTestCase
  setup do
    @reservation = create(:reservation)
  end

  test "searching for a reservation" do
    system_test_signin

    fill_in "search", with: @reservation.name[0..3]
    click_on "Search"
    assert_text @reservation.name
  end

  test "toggling picked_up? and setting of picked_up_at" do
    system_test_signin

    within '#main-navbar' do
      click_on 'Reservations'
    end

    click_on @reservation.name

    assert_not @reservation.picked_up_at
    assert_selector '#picked_up_false'

    # click the box => set the picked up time
    click_on 'reservation-picked-up-toggle'

    assert_selector '#picked_up_true'
    assert @reservation.reload.picked_up_at

    # click the box again => clear the picked up time
    click_on 'reservation-picked-up-toggle'
    assert_selector '#picked_up_false'
    assert_not @reservation.reload.picked_up_at
  end

  test "toggling picked_up? and setting of picked_up_at" do
    system_test_signin

    within '#main-navbar' do
      click_on 'Reservations'
    end

    click_on @reservation.name

    assert_not @reservation.is_missing_at
    assert_selector '#missing_false'

    # click the box => set the picked up time
    click_on 'reservation-missing-toggle'

    assert_selector '#missing_true'
    assert @reservation.reload.is_missing_at

    # click the box again => clear the picked up time
    click_on 'reservation-missing-toggle'
    assert_selector '#missing_false'
    assert_not @reservation.reload.is_missing_at
  end
end
