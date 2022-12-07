require "test_helper"

class Admin::RouteTest < ActiveSupport::TestCase
  test "name presence validation" do
    route = build(:route, name: nil, is_zoned: false)
    assert_not route.valid?
    assert route.errors.of_kind?(:name, :blank)
  end

  test "route geocoded" do
    route = Route.new(name: 'Route test', street: '1760 Susan Place NW', distance: 0.5, city: 'Bainbridge Island', state: 'Washington', country: 'United States', is_zoned: false )
    assert route.valid?
    sleep 1
    assert route.latitude.present?
    assert route.longitude.present?
  end

  test "destroying route should orphan associated reservations" do
    route = create(:route_with_coordinates, is_zoned: false)
    reservation = create(:reservation_with_coordinates, route: route, is_routed: false)

    route.destroy

    reservation.reload
    assert_not reservation.route
  end

  test "route geocoding on address changes" do
    route = create(:route_with_coordinates, is_zoned: false)
    lat, lon = route.latitude, route.longitude
    route.update(street: '9310 NE Midship Ct')
    route.reload

    assert_not_equal lat, route.latitude
    assert_not_equal lon, route.longitude
  end

  test "destroying route leaves reservations" do
    route = create(:route_with_coordinates, is_zoned: false)
    reservations = create_list(:reservation_with_coordinates, 10, is_routed: false, route: route)

    assert_equal route, reservations[0].route
    assert_difference "Reservation.count", 0 do
      route.destroy
    end
    assert_not route.persisted?
  end
end
