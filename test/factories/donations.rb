FactoryBot.define do
  factory :donation do
    reservation { nil }
    amount { "25.00" }
    email { Faker::Internet.email }
  end
end
