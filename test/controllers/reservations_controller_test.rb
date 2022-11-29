require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    routes = [
      { name: 'Winslow North', street: '657 Annie Rose Ln NW', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
      { name: 'Winslow South', street: '400 Harborview Dr SE', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
      { name: 'South Beach', street: '9309 NE South Beach Dr', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
      { name: 'Battle Point', street: '9091 Olympus Beach Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
      { name: 'Bloedel Reserve', street: '16253 Agate Point Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
      { name: 'Eagledale', street: '10837 Bill Point Bluff NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States' }]
    routes.each{ |z| create(:route, name: z[:name], street: z[:street]) }

    @reservation = create :reservation
    @user = create :user
  end

  test "should get new" do
    get new_reservation_url
    assert_response :success
  end

  test "should show reservation" do
    get reservation_url(@reservation)
    assert_response :success
  end

  test "should not show a missing reservation" do 
    assert_raise ActiveRecord::RecordNotFound do
      get reservation_url('bogus id')
    end
  end

  test "should create reservation in step 1 with name, good address, and email and correct status" do
    new_reservation_attributes = build :reservation
    assert_difference("Reservation.count", 1) do
      post reservations_url, params: { reservation: { name: new_reservation_attributes.name, street: new_reservation_attributes.street, email: new_reservation_attributes.email } }
    end
    new_reservation = Reservation.order(updated_at: :asc).last
    assert_redirected_to new_reservation_donation_path(new_reservation)
    assert_equal "You are all set! Your pickup reservation is confirmed.", flash[:notice]
    assert new_reservation.pending_pickup?
  end

  test "creating a reservation with incomplete info" do 
    new_reservation_attributes = build :reservation
    assert_difference("Reservation.count", 0) do
      post reservations_url, params: { reservation: { name: new_reservation_attributes.name, street: new_reservation_attributes.street } }
    end
    assert_response :unprocessable_entity
  end

  test "updating a reservation with incomplete info" do 
    patch reservation_url(@reservation), params: { reservation: { name: nil } }
    assert_response :unprocessable_entity
  end

  test "should geocode and route new perfect address reservation" do
    new_reservation_attributes = build :reservation
    post reservations_url, params: { reservation: { name: new_reservation_attributes.name, street: new_reservation_attributes.street, email: new_reservation_attributes.email } }
    new_reservation = Reservation.order(updated_at: :asc).last
    assert new_reservation.geocoded?
    assert new_reservation.routed?
  end

  test "should geocode and route non-perfect, but corrected address-verified reservation" do
    new_reservation_attributes = build :reservation
    post reservations_url, params: { reservation: { name: new_reservation_attributes.name, street: 'some street', email: new_reservation_attributes.email } }
    reservation = Reservation.order(updated_at: :asc).last
    assert_redirected_to reservation_address_verification_url(reservation)
    assert_not reservation.geocoded?
    assert_not reservation.routed?
    patch reservation_url(reservation), params: { reservation: { street: new_reservation_attributes.street } }
    reservation.reload

    assert reservation.geocoded?
    assert reservation.routed?
  end

  test "should re-geocode and re-route edited reservation" do
    get reservation_url(@reservation)
    assert @reservation.geocoded?
    assert @reservation.routed?

    assert_equal "Winslow South", @reservation.route.name

    patch reservation_url(@reservation), params: { reservation: { street: '16253 Agate Point Rd NE' } }
    assert_redirected_to new_reservation_donation_path(@reservation)

    @reservation.reload
    assert @reservation.geocoded?
    assert @reservation.routed?
    assert_equal "Bloedel Reserve", @reservation.route.name
  end

  test "should remove geocoding and routing on edit with bad-address" do
    patch reservation_url(@reservation), params: { reservation: { street: 'bad address' } }
    assert_redirected_to new_reservation_donation_path(@reservation)
    @reservation.reload

    assert_not @reservation.geocoded?
    assert_not @reservation.routed?
  end

  test "should update reservation" do
    patch reservation_url(@reservation), params: { reservation: { city: @reservation.city, country: @reservation.country, email: @reservation.email, latitude: @reservation.latitude, longitude: @reservation.longitude, name: @reservation.name, phone: @reservation.phone, state: @reservation.state, street: @reservation.street, zip: @reservation.zip } }
    assert_redirected_to new_reservation_donation_path(@reservation)
  end

  test "should not destroy reservation" do
    assert_difference("Reservation.count", 0) do
      delete reservation_url(@reservation)
    end

    assert_redirected_to reservation_path(@reservation)
  end

  test "geocoding on updated reservations" do
    @reservation = create(:reservation_with_coordinates)
    lat,lon = @reservation.latitude, @reservation.longitude
    patch reservation_url(@reservation), params: { reservation: { street: '1760 Susan Place NW' } }

    @updated_reservation = Reservation.find(@reservation.id)
    assert_not_equal lat, @updated_reservation.latitude
    assert_not_equal lon, @updated_reservation.longitude
  end

  test "routing on new reservation" do

  end

  test "new reservation when reservations closed" do 
    Setting.first_or_create.update(is_reservations_open: false)
    assert_not Reservation.open?

    new_reservation_attributes = build :reservation
    assert_difference("Reservation.count", 0) do
      post reservations_url, params: { reservation: { name: new_reservation_attributes.name, street: '1760 Susan Place NW', email: new_reservation_attributes.email } }
    end
    assert_equal "Reservations are CLOSED.", flash[:alert]
    assert_redirected_to root_url
  end

  test "updating reservation when reservations closed" do 
    Setting.first_or_create.update(is_reservations_open: false)
    patch reservation_path(@reservation), params: { reservation: { email: 'new@example.com' } }
    assert flash[:alert].include? "Reservations are no longer changeable."
    assert_redirected_to reservation_url(@reservation)
  end

  test "destroying reservation when reservations closed" do 
    Setting.first_or_create.update(is_reservations_open: false)
    delete reservation_path(@reservation)
    assert flash[:alert].include? "Reservations are no longer changeable."
    assert_redirected_to reservation_url(@reservation)
  end

  test "confirming and unconfirmed reservation" do 
    @reservation.unconfirmed!
    get reservation_url(@reservation)
    assert response.body.include? "Unconfirmed. Not scheduled for pickup."
    post reservation_submit_path(@reservation)
    assert @reservation.reload.pending_pickup?
    assert_redirected_to new_reservation_donation_url(@reservation)
  end

  test "reservation address successful verification" do 
    get reservation_address_verification_url(@reservation)
    assert_response :success
  end

  test "reservation address verification with multiple results" do
    @reservation.update(street: '1761 Su San')
    get reservation_address_verification_url(@reservation)
    assert_response 200 # success, but there is likely a better street address
  end

  test "reservation address verification with no address found" do
    @reservation.update(street: 'jackamo street')
    get reservation_address_verification_url(@reservation)
    assert_response 422
  end

end
