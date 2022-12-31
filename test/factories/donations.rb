FactoryBot.define do
  factory :donation do
    reservation { nil }
    amount { "25.00" }
    form { 2 }
    email { Faker::Name.first_name.downcase + '.' + Faker::Name.last_name.downcase + '@example.com' }

    factory :reservation_donation do 
      reservation
      form { 1 }
    end
  end

end
