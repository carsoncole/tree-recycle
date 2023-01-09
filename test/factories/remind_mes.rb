FactoryBot.define do
  factory :remind_me do
    name { Faker::Name.name }
    email { Faker::Name.first_name.downcase + '.' + Faker::Name.last_name.downcase + '@example.com' }
  end
end
