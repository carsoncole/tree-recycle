FactoryBot.define do
  factory :donation do
    reservation { nil }
    amount { "25.00" }
    email { Faker::Name.first_name.downcase + '.' + Faker::Name.last_name.downcase + '@example.com' }

    factory :reservation_donation do 
      reservation
    end
  end

end
