FactoryBot.define do
  factory :reservation do
    name { Faker::Name.name }
    street { Faker::Address.street_address }
    email { Faker::Internet.email }
    is_confirmed { true }


    factory :reservation_with_phone do
      phone { Faker::PhoneNumber.cell_phone }
    end

    factory :uncompleted_reservation do
      is_confirmed { false }
    end
  end
end
