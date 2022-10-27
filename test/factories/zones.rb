FactoryBot.define do
  factory :zone do
    name { "MyString" }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    distance { 1 }
  end
end
