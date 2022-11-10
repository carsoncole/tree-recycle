require "application_system_test_case"

#OPTIMIZE add more route assignment tests. Not enough
class Admin::RoutesTest < ApplicationSystemTestCase

  def setup
    @routes = [
      { name: 'South Island', street: '10701 NE South Beach Dr', lat: 47.574630345403, lon: -122.5087443506282 },
      { name: 'Commodore', street: '1526 Arthur Pl NW', lat: 47.63822191836735, lon: -122.5278680204082  },
      { name: 'Day Road', street: '9229 Day Road', lat: 47.67917440119761, lon:  -122.5272910538922 }
    ]
  end

  test "creating routes that are correctly geocoded" do
    system_test_signin
    click_on 'Routes'

    table_row_count = 1
    assert_equal find('#routes-table').all(:css, 'tr').count, table_row_count

    @routes.each do |z|
      click_on 'new-route-link'
      fill_in "Name", with: z[:name]
      fill_in "Street", with: z[:street]
      fill_in "City", with: 'Bainbridge Island'
      fill_in "State", with: 'Washington'
      click_on "Save"
      table_row_count += 1
      assert_text "Route was successfully created."
      assert Route.where(name: z[:name]).first.geocoded?
      assert_equal find('#routes-table').all(:css, 'tr').count, table_row_count
    end
  end

  test "correct route assignments" do
    @routes.each do |z|
      create(:route, name: z[:name], street: z[:street], latitude: z[:lat], longitude: z[:lon], city: 'Bainbridge Island', state: 'Washington')
    end

    # create a reservation
    visit root_url
    click_on "Reserve a tree pickup"
    fill_in "reservation[name]", with: 'Carson'
    fill_in "reservation[street]", with: '1760 Susan Place NW'
    fill_in "Email", with: 'admin@example.com'
    click_on "Register your address"

    system_test_signin
    reservation = Reservation.order(created_at: :desc).first
    click_on 'Reservations'
    click_on "process-route-button-#{reservation.id}"
    click_on 'Carson'
    within "#delivery" do
      assert_text "Commodore"
    end
  end

end
