FactoryBot.define do
  factory :driver  do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone }
  end
end
