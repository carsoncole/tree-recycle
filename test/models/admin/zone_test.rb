require "test_helper"

class Admin::ZoneTest < ActiveSupport::TestCase

  test "destroying zone leaves routes" do
    zone = create(:zone)
    route = create(:route_with_coordinates, is_zoned: false, zone: zone)

    assert_equal zone, route.zone
    assert_difference "Route.count", 0 do
      zone.destroy
    end
    assert route.persisted?
    assert_not zone.persisted?
    assert_not route.reload.zone
  end

  test "destroying zone leaves drivers" do
    zone = create(:zone)
    drivers = create_list(:driver, 5, zone: zone)

    assert_equal zone, drivers[0].zone
    assert_difference "Driver.count", 0 do
      zone.destroy
    end

    assert_not zone.persisted?
    assert_not drivers[0].reload.zone
  end
end
