require 'faker'
include FactoryBot::Syntax::Methods

User.create(email: 'admin@example.com', password: 'password')

Setting.first_or_create  do |setting|
  setting.site_title = 'Troop 1564 & 1804 Tree Recycle'
  setting.site_description = "This is the annual Tree Recycle fundraiser for Troop 100. Residents of Anytown, USA can have their Christmas trees recycle by making an online reservation and make an optional donation to support the Troop and it's Scouts."
  setting.contact_email = 'admin@example.com'
  setting.contact_name = 'John Doe'
  setting.pickup_date = Date.today + 1.month
  setting.organization_name = 'BSA Troop 100'
  setting.default_city = "Bainbridge Island"
  setting.default_state = "Washington"
  setting.default_country = "United States"
end

# 50.times do
#   FactoryBot.create([
#     'reservation',
#     'reservation_with_email',
#     'reservation_with_phone',
#     'reservation_with_phone',
#     'reservation_with_email_and_phone',
#     'reservation_with_email_and_phone',
#     'reservation_with_email_and_phone'
#   ][rand(7)].to_sym)
# end


streets = [
'1760 Susan Place',
'14265 Silven Ave NE',
'2250 Upper Farms Rd NE',
'4178 El Cimo Ln NE',
'16910 Agate Point Rd NE',
'7501 NE West Port Madison Rd',
'16279 Reitan Rd NE',
'11669 N Madison Ave NE',
'6230 NE Williams Ln',
'786 Fairview Ave NE',
'4932 McDonald Ave NE',
'8023 NE Hidden Cove Rd',
'14100 N Madison Ave NE',
'7881 NE Day Rd W',
'9733 NE Sunny Hill Cir',
'6619 Crystal Springs Dr NE',
'14625 Sunrise Dr NE',
'10699 Hart Ln NE',
'3083 Point White Dr NE',
'9596 Green Spot Pl NE',
'10139 NE Kitsap St',
'5484 NE Eagle Harbor Dr',
'9195 North Town Dr NE',
'1416 Elizabeth Pl NW',
'9368 Endicott St NE',
'9282 Fletcher Bay Rd NE',
'7030 NE High School Rd',
'456 Eakin Dr NW',
'4913 NE Tolo Rd',
'11260 Arrow Point Dr NE',
'6500 Island Center Rd NE',
'10768 Manitou Park Blvd NE',
'7561 NE Emerald Way',
'7733 NE Hansen Rd',
'12410 Sunrise Dr NE',
'10810 Falk Rd NE',
'5370 NE Fletcher Landing',
'11676 Sunrise Dr NE',
'12219 Kallgren Rd NE',
'10075 Manitou Beach Dr NE',
'10044 Edgecombe Pl NE',
'9482 Green Spot Pl NE',
'9505 NE Fox Den Ln',
'8699 NE Triple Crown Dr',
'1895 Commodore Ln NW',
'8221 Peggy Ln NE',
'12615 Kallgren Rd NE',
'9978 NE Torvanger Rd',
'9385 NE North Town Loop',
'5012 Crystal Springs Dr NE',
'6578 NE Tara Ln',
'9235 North Town Dr NE',
'5789 Crystal Springs Dr NE',
'6015 Crystal Springs Dr NE',
'11306 Larix Pl NE',
'9739 Big Fir Ln NE',
'9391 North Town Dr NE',
'9427 Capstan Dr NE',
'9314 Capstan Dr NE',
'6391 NE Tolo Rd',
'13540 Phelps Rd NE',
'9536 NE North Town Loop',
'8960 NE Day Rd E',
'8451 Springridge Rd NE',
'8150 NE Hansen Rd',
'9301 Capstan Dr NE',
'9310 NE Midship Ct',
'9423 Capstan Dr NE',
'8757 Rosario Pl NW',
'1125 Lovell Ave NW',
'867 Taurnic Pl NW',
'661 Al Dorsey Ln NW',
'8099 NE Bucklin Hill Rd',
'6895 NE Hanks Ln'


]

# streets.each do |s|
#   reservation = build(:reservation)
#   Reservation.create(name: reservation.name, street: s, is_completed: true)
# end

zones = [
[name: 'South Island/Fort Ward', distance: 1.35, street: '10701 NE South Beach Dr', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Wing Point', distance: 0.25, street: '811 Cherry Ave', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Winslow', distance: 0.6, street: '305 Madison Ave N', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Port Madison', distance: 0.7, street: '9799 NE Lafayette Ave', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Agate Pass', distance: 0.6, street: '16550 Agate Pass Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Seabold', distance: 0.5, street: '14756 Henderson Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Fletcher Bay', distance: 0.5, street: '12453 Fletcher Bay Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Point White', distance: 0.6, street: '4160 Palomino Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Manzanita', distance: 0.6, street: '12453 Fletcher Bay Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Manitou Beach', distance: 0.5, street: '10311 Manitou Beach Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Day Road', distance: 0.6, street: '9229 Day Road', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Meadowmeer/Kuora', distance: 0.6, street: '11246 Fieldstone Ln NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'North Town Woods', distance: 0.4, street: '9376 North Town Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Battlepoint', distance: 0.6, street: '10715 Arrow Point Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Lynwood', distance: 0.6, street: '7575 NE Golden Ln', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Blakely', distance: 0.6, street: '4890 Taylor Ave NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Rolling Bay', distance: 0.6, street: '10075 NE Winther Rd', city: 'Bainbridge Island', state: 'Washington', country: 'United States'],
[name: 'Commodore', distance: 0.13, street: '1526 Arthur Pl NW', city: 'Bainbridge Island', state: 'Washington', country: 'United States']
]



zones.each do |zone|
  Zone.create(zone)
end
