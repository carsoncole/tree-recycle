FactoryBot.define do
  factory :reservation do
    name { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    street_1 { "MyString" }
    street_2 { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip { "MyString" }
    country { "MyString" }
    latitude { "9.99" }
    longitude { "9.99" }
  end
end
