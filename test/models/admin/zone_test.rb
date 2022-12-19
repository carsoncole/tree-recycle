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
end
