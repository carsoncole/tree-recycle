FactoryBot.define do
  factory :reservation do
    name { Faker::Name.name }
    street { Faker::Address.street_address }
    email { Faker::Internet.email }
    is_completed { true }


    factory :reservation_with_phone do
      phone { Faker::PhoneNumber.cell_phone }
    end

    factory :uncompleted_reservation do
      is_completed { false }
    end
  end
end
