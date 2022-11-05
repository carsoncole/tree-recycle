require "application_system_test_case"

#OPTIMIZE add more zone assignment tests. Not enough
class Admin::ZonesTest < ApplicationSystemTestCase

  def setup
    @zones = [
      { name: 'South Island', street: '10701 NE South Beach Dr', lat: 47.574630345403, lon: -122.5087443506282 },
      { name: 'Commodore', street: '1526 Arthur Pl NW', lat: 47.63822191836735, lon: -122.5278680204082  },
      { name: 'Day Road', street: '9229 Day Road', lat: 47.67917440119761, lon:  -122.5272910538922 }
    ]
  end

  test "creating zones that are correctly geocoded" do
    system_test_signin
    click_on 'Zones'

    table_row_count = 1
    assert_equal find('#zones-table').all(:css, 'tr').count, table_row_count

    @zones.each do |z|
      click_on 'new-zone-link'
      fill_in "Name", with: z[:name]
      fill_in "Street", with: z[:street]
      fill_in "City", with: 'Bainbridge Island'
      fill_in "State", with: 'Washington'
      click_on "Save"
      table_row_count += 1
      assert_text "Zone was successfully created."
      assert Zone.where(name: z[:name]).first.geocoded?
      assert_equal find('#zones-table').all(:css, 'tr').count, table_row_count
    end
  end

  test "correct zone assignments" do
    @zones.each do |z|
      create(:zone, name: z[:name], street: z[:street], latitude: z[:lat], longitude: z[:lon], city: 'Bainbridge Island', state: 'Washington')
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
    click_on "process-zone-button-#{reservation.id}"
    click_on 'Carson'
    within "#delivery" do
      assert_text "Commodore"
    end
  end

end
