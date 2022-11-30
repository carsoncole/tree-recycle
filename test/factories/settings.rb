FactoryBot.define do
  factory :setting do
    organization_name { 'Troop 100' }
    site_title { "Anytown USA Tree Recycle"}
    site_description { "This is the annual Tree Recycle fundraiser for Troop 100. Residents of Anytown, USA can have their Christmas trees recycle by making an online reservation and make an optional donation to support the Troop and it's Scouts." }

    pickup_date_and_time { '20270102 08:00:00' }
    pickup_date_and_end_time { '20270102 14:00:00' }
    sign_up_deadline_at { '20270101 21:00:00' }
  end
end