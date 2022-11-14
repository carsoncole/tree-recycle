FactoryBot.define do
  factory :route do
    name { Faker::Address.street_name }
    street { Faker::Address.street_address }
    city { 'Bainbridge Island' }
    state { 'Washington' }
    distance { 1 }

    factory :route_with_zone do
      zone
    end
  end
end
