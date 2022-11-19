FactoryBot.define do
  factory :route do
    name { Faker::Address.street_name }
    street { Faker::Address.street_address }
    city { 'Bainbridge Island' }
    state { 'Washington' }
    distance { 1 }
    latitude { 47.6259654 }
    longitude { -122.517533 }

    factory :route_with_zone do
      zone
    end

    factory :route_without_coordinates do
      latitude { nil }
      longitude { nil }
    end
  end
end
