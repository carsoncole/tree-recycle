FactoryBot.define do
  factory :reservation do
    name { Faker::Name.name }
    street { '215 Ericksen Ave NE' }
    email { Faker::Name.first_name.downcase + '.' + Faker::Name.last_name.downcase + '@example.com' }


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
      status { 1 }
    end

    factory :remind_me do
      street { nil }
      status { :remind_me }
    end

    factory :reservation_with_route do
      route
    end

    factory :archived_reservation do
      status { :archived }
      latitude { 47.6259654 }
      longitude { -122.517533 }
      is_routed { false }
    end
  end
end
