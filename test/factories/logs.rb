FactoryBot.define do
  factory :log do
    message { Faker::Lorem.sentence }
  end
end
