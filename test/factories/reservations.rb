FactoryBot.define do
  factory :reservation do
    name { Faker::Name.name }
    street { '215 Ericksen Ave NE' }
    email { Faker::Name.first_name.underscore + '@example.com' }

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
      status { 1 }
    end

    factory :reservation_with_route do
      route
    end

    factory :archived_with_coordinates_reservation do
      status { :archived }
      latitude { 47.6259654 }
      longitude { -122.517533 }
    end
  end
end
