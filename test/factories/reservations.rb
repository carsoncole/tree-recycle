FactoryBot.define do
  factory :reservation do
    name { "MyString" }
    email { Faker::Internet.email }
    street_1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { "MyString" }
  end
end
