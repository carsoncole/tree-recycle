FactoryBot.define do
  factory :reservation do
    name { "MyString" }
    street_1 { Faker::Address.street_address }
  end
end
