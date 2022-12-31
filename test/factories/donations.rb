FactoryBot.define do
  factory :donation do
    reservation { nil }
    amount { "25.00" }
    form { :cash_or_check }
    email { Faker::Name.first_name.downcase + '.' + Faker::Name.last_name.downcase + '@example.com' }

    factory :reservation_donation do 
      reservation
      form { :online }
    end
  end

end
