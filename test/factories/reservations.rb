FactoryBot.define do
  factory :reservation do
    name { "MyString" }
    street { Faker::Address.street_address }
  end
end
