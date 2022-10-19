FactoryBot.define do
  factory :settings do
    organization_name { "MyString" }
    contact_name { "MyString" }
    contact_email { "MyString" }
    contact_phone { "MyString" }
    description { "MyText" }
    pickup_date { "2022-10-19" }
  end
end
