FactoryBot.define do
  factory :reservation do
    name { Faker::Name.name }
    street { Faker::Address.street_address }
    email { Faker::Internet.email }
    status { 0 }

    factory :reservation_with_good_address do
      street { '215 Ericksen Ave NE' }
    end

    factory :reservation_with_coordinates do
      latitude { 47.6259654 }
      longitude { -122.517533 }
    end

    factory :reservation_with_phone do
      phone { Faker::PhoneNumber.cell_phone }
    end
  end
end
