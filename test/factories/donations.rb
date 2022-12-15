FactoryBot.define do
  factory :donation do
    reservation { nil }
    amount { "25.00" }
    email { Faker::Name.first_name.underscore + '@example.com' }

    factory :reservation_donation do 
      reservation
    end
  end

end
