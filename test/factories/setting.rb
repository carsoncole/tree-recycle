FactoryBot.define do
  factory :setting do
    organization_name { "MyString" }
    contact_name { Faker::Name.name }
    contact_email { Faker::Internet.email }
    contact_phone { Faker::PhoneNumber.cell_phone }
    description { "MyText" }
    pickup_date_and_time { Time.now + 1.month }
    sign_up_deadline_at { Time.now + 1.month - 1.day }
  end
end
