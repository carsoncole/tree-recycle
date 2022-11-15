FactoryBot.define do
  factory :zone do
    name { Faker::Name.name }
    street { '1760 Susan Place NW'}

    factory :zone_with_coordinates do
      latitude { 47.6259654 }
      longitude { -122.517533 }
    end
  end
end
