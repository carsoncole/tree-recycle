require "test_helper"

#OPTIMIZE Queued emails need work
class ReservationTest < ActiveSupport::TestCase
  setup do
    @routes = [
    { name: 'Battle Point', street: '9091 Olympus Beach Rd NE', zone: 'West', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
    { name: 'Bloedel Reserve', street:'16253 Agate Point Rd NE', zone: 'West', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
    { name: 'High School', street: '9458 Capstan Dr NE', zone: 'Center', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
    { name: 'Lynwood Center', street: '5919 Blakely Ave NE', zone: 'South', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
    { name: 'Winslow South', street: '400 Harborview Dr SE', zone: 'Center', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
    { name: 'Point White', street: '3154 Point White Dr NE', zone: 'South', city: 'Bainbridge Island', state: 'Washington', country: 'United States'}
    ]

    @zones = [
    { name: 'Center', street: '7729 Finch Rd NE', latitude: 0.4763398639759036e2, longitude: -0.12253715896385542e3, city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
    { name: 'West', street: '5685 NE Wild Cherry Ln', latitude: 0.4763941859060403e2, longitude: -0.12257140608053692e3, city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
    { name: 'South', street: '8792 NE Oddfellows Rd', latitude: 0.4759832051756319e2, longitude: -0.12253334751868852e3, city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
    { name: 'East', street: '10215 Manitou Beach Dr NE', latitude: 0.476568128848823e2, longitude: -0.1225093191081681e3, city: 'Bainbridge Island', state: 'Washington', country: 'United States' }
    ]
  end

  test "geocoding, status, logging of new reservations" do
    reservation = build(:reservation)
    assert_not reservation.geocoded?
    reservation.save
    assert reservation.geocoded?
    assert_equal 1, reservation.logs.count
    assert_equal reservation.status, 'unconfirmed'
  end

  test "downcasing email" do
    assert_equal 'downcased@example.com', create(:reservation, email: 'DownCased@example.com').email
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

  test "routing of new geocoded reservations" do
    @routes.each{ |route| create(:route, name: route[:name], street: route[:street]) }
    reservation = build(:reservation, street: '215 Ericksen Ave NE')
    assert_not reservation.routed?
    reservation.save
    assert reservation.geocoded?

    reservation.route!
    reservation.save
    assert reservation.routed?
    assert_equal 'Winslow South', reservation.route.name
  end

  test "re-geocoding on updated reservations" do
    reservation = create(:reservation_with_coordinates)
    lat, lon = reservation.latitude, reservation.longitude
    reservation.update(street: '1760 Susan Place NW')
    assert_not_equal reservation.latitude, lat
    assert reservation.geocoded?
    assert_not_equal lat, reservation.latitude
    assert_equal 47.640112018045, reservation.latitude
  end

  test "no geocoding of new reservation with coordinates provided" do
    reservation = build(:reservation_with_coordinates)
    assert reservation.geocoded? # geocoded by default
    reservation.street = 'pluto' # lat, long as been provided stopping geocoding
    reservation.save
    assert reservation.geocoded? # still geocoded
    assert_equal 47.6259654, reservation.latitude # this would be reset to nil if geocoded again
  end

  test "re-routing and zone on updated reservations" do
    @zones.each {|z| Zone.create(name: z[:name], street: z[:street]) }
    @routes.each { |r| Route.create(name: r[:name], street: r[:street], zone_id: Zone.find_by_name(r[:zone]).id, is_zoned: false ) }

    reservation = create(:reservation_with_coordinates)
    assert_equal "Winslow South", reservation.route.name
    reservation.update(street: '9509 NE South Beach Dr')
    assert reservation.geocoded?
    assert reservation.routed?
    assert_equal 'Point White', reservation.route.name, 'wrong route'
    assert_equal "South", reservation.route.zone.name, 'wrong zone'
  end

  test "destroying reservations older than N months" do 
    reservations = create_list(:reservation_with_coordinates, 5, is_routed: false)
    reservations[0].update(created_at: Time.now + 24.months)
    
    assert_equal 5, Reservation.count 
    Reservation.destroy_reservations_older_than_months(12)
    assert_equal 4, Reservation.count 
  end

  test "merging unarchived with archived" do
    create_list(:reservation_with_coordinates, 10, status: :pending_pickup, is_routed: false)
    create_list(:remind_me, 5)
    assert_equal 15, Reservation.not_archived.count
    assert_difference 'Reservation.archived.count', 10 do
      Reservation.merge_unarchived_with_archived!
    end
  end

  test "process post event" do
    create_list(:reservation_with_coordinates, 10, status: :pending_pickup, is_routed: false)
    create_list(:remind_me, 10)
    assert_equal 10, Reservation.active.count # pending pickups: 10
    assert_equal 10, Reservation.not_active.count # remind mes: 10
    assert_difference "Reservation.active.count", -10 do
      Reservation.process_post_event!
    end
    assert_equal 20, Reservation.not_active.count # remind_mes: 10 + archived: 10
  end

  test "normalizig of phone" do
    reservation = create(:reservation_with_coordinates, is_routed: false, phone: '206 555 1 212')
    assert_equal '+12065551212', reservation.phone

    reservation = create(:reservation_with_coordinates, is_routed: false, phone: '3035559850')
    assert_equal '+13035559850', reservation.phone

    reservation = create(:reservation_with_coordinates, is_routed: false, phone: '13035559850')
    assert_equal '+13035559850', reservation.phone

    reservation = create(:reservation_with_coordinates, is_routed: false, phone: '(206) 123-1234')
    assert_equal '+12061231234', reservation.phone
  end

  test "recipients of marketing emails" do
    assert_empty Reservation.reservations_to_send_marketing_emails('is_marketing_email_1_sent')

    confirmed_reservations = create_list(:reservation, 3)
    assert_equal 0, Reservation.reservations_to_send_marketing_emails('is_marketing_email_1_sent').count

    archived_reservations = create_list(:archived_reservation, 5)
    assert_equal 5, Reservation.reservations_to_send_marketing_emails('is_marketing_email_1_sent').count
  end

  test "merging archived with newly placed reservations" do
    archived_reservations = create_list(:archived_reservation, 2)
    assert_equal 2, Reservation.archived.count
    new_reservation_by_prior_customer = create(:reservation_with_coordinates, email: archived_reservations[0].email)

    # archived years recycling should be carried over
    assert_equal 1, Reservation.archived.count
    assert_equal 1, Reservation.active.count
    assert_equal 2, Reservation.active.first.years_recycling

    # archived donations should be carried over
    assert_equal 2, Reservation.active.first.donations.count
  end
end
