FactoryBot.define do
  factory :route do
    name { Faker::Address.street_name }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    distance { 1 }
    latitude { 47.574630345403 }
    longitude { -122.5087443506282 }
  end
end
