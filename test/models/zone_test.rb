require "test_helper"

class ZoneTest < ActiveSupport::TestCase
  test "name presence validation" do
    zone = build(:zone, name: nil)

    assert_not zone.valid?
    assert zone.errors.of_kind?(:name, :blank)
  end

  test "zone coordinates present" do
    zone = Zone.new(name: 'Zone test', street: '1760 Susan Place NW', city: 'Bainbridge Island', state: 'Washington', country: 'United States' )
    assert zone.valid?
    assert zone.latitude
    assert zone.longitude
  end

  test "destroying zone should orphan associated reservations" do
    zone = create(:zone)
    reservation = create(:reservation)
    reservation.update(zone_id: zone.id)

    assert_equal reservation.zone, zone

    assert_difference 'Zone.count', -1 do
      zone.destroy
    end

    reservation.reload
    assert_not reservation.zone
  end
end
