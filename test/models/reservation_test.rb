require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @routes = [
    { name: 'Battle Point', street: '9091 Olympus Beach Rd NE', zone: 'West' },
    { name: 'Bloedel Reserve', street:'16253 Agate Point Rd NE', zone: 'West' },
    { name: 'High School', street: '9458 Capstan Dr NE', zone: 'Center' },
    { name: 'Lynwood Center', street: '5919 Blakely Ave NE', zone: 'South' }
    ]

    @zones = [
    { name: 'Center', street: '7729 Finch Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', latitude: 0.4763398639759036e2, longitude: -0.12253715896385542e3 },
    { name: 'West', street: '5685 NE Wild Cherry Ln', city: 'Bainbridge Island', state: 'Washington', country: 'United States', latitude: 0.4763941859060403e2, longitude: -0.12257140608053692e3 },
    { name: 'South', street: '8792 NE Oddfellows Rd', city: 'Bainbridge Island', state: 'Washington', country: 'United States', latitude: 0.4759832051756319e2, longitude: -0.12253334751868852e3 },
    { name: 'East', street: '10215 Manitou Beach Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', latitude: 0.476568128848823e2, longitude: -0.1225093191081681e3 }
    ]

  end

  #TODO fixes
  test "geocoding, logging of new reservations" do
    # reservation = build(:reservation, zone_id: zone.id, status: :pending_pickup)
    # assert_not reservation.geocoded?
    # reservation.save
    # assert reservation.geocoded?
    # assert_equal 1, reservation.logs.count
  end



  test "setting of default unconfirmed status" do
    reservation = create(:reservation)
    assert_equal reservation.status, 'unconfirmed'
    assert reservation.geocoded?
  end

  test "name validation" do
    reservation = build(:reservation_with_coordinates, name: nil)
    assert_not reservation.valid?
    assert reservation.errors.of_kind?(:name, :blank)
  end

  test "street address validation" do
    reservation = build(:reservation_with_coordinates, street: nil)
    assert_not reservation.valid?
    assert reservation.errors.of_kind?(:street, :blank)
  end

  test "geocoding of new reservations" do
    reservation = build(:reservation)
    assert_not reservation.geocoded?
    reservation.save
    assert reservation.geocoded?
  end

  test "routing of new geocoded reservations" do
    @routes.each{ |z| create(:route, name: z[:name], street: z[:street]) }
    reservation = build(:reservation)
    assert_not reservation.routed?
    reservation.save
    assert reservation.geocoded?
    assert reservation.routed?
    assert_equal 'Ferncliff', reservation.route.name
  end

  test "re-geocoding on updated reservations" do
    reservation = create(:reservation_with_coordinates)
    lat, lon = reservation.latitude, reservation.longitude
    reservation.update(street: '1760 Susan Place NW')
    assert_not_equal reservation.latitude, lat
    assert reservation.geocoded?
    assert_not_equal lat, reservation.latitude
    assert_equal reservation.latitude, 47.64001144897959
  end

  test "no geocoding of new reservation with coordinates provided" do
    reservation = build(:reservation_with_coordinates)
    assert reservation.geocoded? # geocoded by default

    reservation.street = 'pluto'
    reservation.save
    assert reservation.geocoded? # still geocoded
    assert_equal reservation.latitude, 47.6259654 # this would be reset to nil if geocoded again
  end

  test "re-routing and zone on updated reservations" do
    @zones.each {|z| Zone.create(name: z[:name], street: z[:street], city: z[:city], state: z[:state], country: z[:country] )}
    @routes.each{ |r| Route.create(name: r[:name], street: r[:street], zone_id: Zone.find_by_name(r[:zone]).id) }

    reservation = create(:reservation_with_coordinates)
    route = reservation.route
    assert_equal "Battle Point", reservation.route.name
    reservation.update(street: '9509 NE South Beach Dr')
    assert reservation.geocoded?
    assert reservation.routed?
    assert_equal 'South Beach', reservation.route.name, 'wrong route'
    assert_equal "South", reservation.route.zone.name, 'wrong zone'
  end
end
