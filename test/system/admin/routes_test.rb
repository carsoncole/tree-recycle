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

    assert_equal 2, find('#admin-zones .zones-table').all(:css, 'tr').count

    zone_1 = create(:zone)

    @routes.each do |z|
      click_on 'Route'
      fill_in "Name", with: z[:name]
      fill_in "Street", with: z[:street]
      fill_in "City", with: 'Bainbridge Island'
      fill_in "State", with: 'Washington'
      click_on "Save"

      within "#flash" do
        assert_text "Route was successfully created."
      end
      assert Route.where(name: z[:name]).first.geocoded?

      within "#admin-zones .zones-table" do
        assert_text z[:name], count: 0
      end
    end
    assert_equal 2, find('#admin-zones .zones-table').all(:css, 'tr').count # TH, Zone 'ALL'

    reservation = create(:reservation_with_coordinates)
    assert_equal 2, find('#admin-zones .zones-table').all(:css, 'tr').count # TH, Zone 'ALL'

    route = create(:route_with_zone)
    reservation = create(:reservation_with_coordinates, route_id: route.id)
    click_on 'Routes'

    within "#zone-#{route.zone.id}" do
      assert_text route.name
      assert_text route.zone.name.upcase
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
    assert_text "Commodore"
  end

end
