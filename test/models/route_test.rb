require "test_helper"

class RouteTest < ActiveSupport::TestCase
  test "name presence validation" do
    route = build(:route, name: nil)

    assert_not route.valid?
    assert route.errors.of_kind?(:name, :blank)
  end

  test "route coordinates present" do
    route = Route.new(name: 'Route test', street: '1760 Susan Place NW', distance: 0.5, city: 'Bainbridge Island', state: 'Washington', country: 'United States' )
    assert route.valid?
    assert route.latitude.present?
    assert route.longitude.present?
  end

  test "destroying route should orphan associated reservations" do
    route = create(:route)
    reservation = create(:reservation_with_coordinates)
    reservation.update(route_id: route.id)

    assert_equal reservation.route, route

    assert_difference 'Route.count', -1 do
      route.destroy
    end

    reservation.reload
    assert_not reservation.route
  end
end
