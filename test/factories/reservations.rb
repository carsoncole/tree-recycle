FactoryBot.define do
  factory :reservation do
    name { Faker::Name.name }
    street { '215 Ericksen Ave NE' }
    email { Faker::Internet.unique.email }
    status { :pending_pickup }


    after :create do |reservation|
      create :donation, reservation: reservation
    end

    factory :reservation_with_bad_address do
      street { Faker::Address.street_name }
      status { 0 }
    end

    factory :reservation_with_no_routing do
      is_routed { false }
    end

    factory :reservation_with_coordinates do
      latitude { 47.6259654 }
      longitude { -122.517533 }
      status { :pending_pickup }

      factory :reservation_picked_up do
        status { :picked_up }
        is_routed { false }
        is_geocoded { false }
      end
    end

    factory :reservation_with_route do
      route
    end

    factory :unconfirmed_reservation do
      status { :unconfirmed }
    end

    factory :archived_reservation do
      status { :archived }
      latitude { 47.6259654 }
      longitude { -122.517533 }
      is_routed { false }

      factory :unsubscribed_reservation do
        no_emails { true }
      end


    end
  end
end
