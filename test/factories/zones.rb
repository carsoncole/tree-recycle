FactoryBot.define do
  factory :zone do
    name { Faker::Name.name }
    street { '1760 Susan Place NW'}
  end
end
