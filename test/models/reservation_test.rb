require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @routes = [
      { name: 'Battle Point', street: '9091 Olympus Beach Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'West' },
      { name: 'Bloedel Reserve', street:'16253 Agate Point Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'West' },
      { name: 'Eagledale', street: '10837 Bill Point Bluff NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'South' },
      { name: 'Ferncliff', street: '1017 Aaron Ave NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'East' },
      { name: 'Fletcher Bay', street: '9098 Fletcher Bay Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'West' },
      { name: 'Fort Ward', street: '1747 Parade Grounds Ave NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'South' },
      { name: 'High School', street: '9458 Capstan Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'Center' },
      { name: 'Island Center', street: '6820 Fletcher Bay Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'West' },
      { name: 'Lovgren', street: '9180 NE Lovgreen Rd', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'East' },
      { name: 'Lynwood Center', street: '5919 Blakely Ave NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'South' },
      { name: 'Meadowmeer', street: '8458 NE Meadowmeer Dr', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'West' },
      { name: 'New Brooklyn', street: '8245 New Holland Ct', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'West' },
      { name: 'Phelps', street: '15740 Euclid Ave NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'West' },
      { name: 'Point White', street: '3154 Point White Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States', zone: 'South' }
    ]

      @zones = [
        { name: 'Center', street: '8222 NE Carmella Ln', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
        { name: 'West', street: '5685 NE Wild Cherry Ln', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
        { name: 'South', street: '8792 NE Oddfellows Rd', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
        { name: 'East', street: '10215 Manitou Beach Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States' }
      ]

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
    @routes.each{ |r| create(:route, name: r[:name], street: r[:street], zone_id: Zone.find_by_name(r[:zone]).id) }

    reservation = create(:reservation_with_coordinates)
    route = reservation.route
    reservation.update(street: '3083 Point White Dr NE')
    assert reservation.geocoded?
    assert reservation.routed?
    assert_not_equal reservation.route, route
    assert_equal 'South Beach', reservation.route.name
    assert_equal "Point White", reservation.route.zone.name
  end

  # test "10027 NE Point View Dr" do
    # something wrong with this address as it won't geocode
  # end
end
