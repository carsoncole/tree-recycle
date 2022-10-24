FactoryBot.define do
  factory :setting do
    organization_name { "MyString" }
    contact_name { Faker::Name.name }
    contact_email { Faker::Internet.email }
    contact_phone { Faker::PhoneNumber.cell_phone }
    description { "MyText" }
    pickup_date { "2022-10-19" }
  end
end
