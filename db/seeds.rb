require 'faker'

User.create(email: 'admin@example.com', password: 'password')

Setting.first_or_create  do |setting|
  setting.site_title = 'Troop 100 Tree Recycle'
  setting.site_description = "This is the annual Tree Recycle fundraiser for Troop 100. Residents of Anytown, USA can have their Christmas trees recycle by making an online reservation and make an optional donation to support the Troop and it's Scouts."
  setting.contact_email = 'admin@example.com'
  setting.contact_name = 'John Doe'
  setting.pickup_date = Date.today + 1.month
  setting.organization_name = 'BSA Troop 100'
  setting.default_city = "Bainbridge Island"
  setting.default_state = "Washington"
  setting.default_country = "United States"
end

50.times do
  FactoryBot.create([
    'reservation',
    'reservation_with_email',
    'reservation_with_phone',
    'reservation_with_phone',
    'reservation_with_email_and_phone',
    'reservation_with_email_and_phone',
    'reservation_with_email_and_phone'
  ][rand(7)].to_sym)
end


zones = [
[name: 'South Island/Fort Ward', distance: 1.35, street: '10701 NE South Beach Dr', city: 'Bainbridge Island', state: 'Washington', country: 'United States']
]

zones.each do |zone|
  Zone.create(zone)
end
