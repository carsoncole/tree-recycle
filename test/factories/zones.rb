FactoryBot.define do
  factory :zone do
    name { Faker::Name.name }
    street { '1760 Susan Place NW'}
    city { 'Bainbridge Island' }
    state { 'Washington' }
    country { 'United States' }
    latitude { 47.6259654 }
    longitude { -122.517533 }

    factory :zone_without_coordinates do
      latitude { nil }
      longitude { nil }
    end
  end
end
