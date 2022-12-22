FactoryBot.define do
  factory :route do
    name { Faker::Address.street_name }
    street { '1760 Susan Place' }
    city { 'Bainbridge Island' }
    state { 'Washington' }
    distance { 1 }

    factory :route_with_zone do
      zone
    end

    factory :route_with_coordinates do
      latitude { 47.6259654 }
      longitude { -122.517533 }
    end

    factory :route_without_coordinates do
      latitude { nil }
      longitude { nil }
    end
    
    factory :route_battlepoint do 
      name { 'Battlepoint' }
      street { '9091 Olympus Beach Rd NE' }
      latitude { 47.646477104939216 }
      longitude { -122.5810297797926 }
    end

    factory :route_winslow_north do 
      name { 'Winslow North' }
      street { '657 Annie Rose Ln NW' }
      latitude { 47.630273714285714 }
      longitude { -122.52775357142858 }
    end

    factory :route_high_school do 
      name { 'High School' }
      street { '9458 Capstan Dr NE' }
      latitude { 47.640161093604064 }
      longitude { -122.53038800087906 }
    end
  end
end
