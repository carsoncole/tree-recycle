require "test_helper"

class Admin::RouterTest < ActiveSupport::TestCase

  test "routing a reservation" do 
    route_battlepoint = create(:route_battlepoint)

    @reservation = create(:reservation, street: '1760 Susan Place' )

    # should route to the only 1 existing route
    assert_equal route_battlepoint, @reservation.route
    assert_equal 2.51, @reservation.distance_to_route.round(2)

    # should route to the newer closer route
    route_winslow = create(:route_winslow_north)
    @reservation.route!
    @reservation.save

    assert_equal 0.68, @reservation.distance_to_route.round(2)
    assert_equal route_winslow, @reservation.reload.route

    # should route to the newer even closer route
    route_high_school = create(:route_high_school)
    @reservation.route!
    @reservation.save
    assert_equal route_high_school, @reservation.reload.route
  end

end