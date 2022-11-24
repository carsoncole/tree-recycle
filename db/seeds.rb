require 'faker'
include FactoryBot::Syntax::Methods

User.create(email: 'admin@example.com', password: 'password')

Setting.first_or_create  do |setting|
  setting.site_title = 'Troop 100 Tree Recycle'
  setting.site_description = "This is the annual Tree Recycle fundraiser for Troop 100. Residents of Anytown, USA can have their Christmas trees recycle by making an online reservation and make an optional donation to support the Troop and it's Scouts."
  setting.description = 'Anytown Troop 100 holds an annual Christmas tree recycling fundraiser to support its annual programs, assisting Scouts in attending camps and other outdoor adventures. '
  setting.contact_email = 'admin@example.com'
  setting.contact_name = 'John Doe'
  setting.contact_phone = '206-555-1212'
  setting.pickup_date_and_time = Date.today + 2.month
  setting.pickup_date_and_end_time = Date.today + 2.month + 6.hours
  setting.sign_up_deadline_at = Date.today + 2.month - 1.day
  setting.organization_name = 'BSA Troop 100'
end

zones = [
  { name: 'Center', street: '7729 Finch Rd NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
  { name: 'West', street: '5685 NE Wild Cherry Ln', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
  { name: 'South', street: '8792 NE Oddfellows Rd', city: 'Bainbridge Island', state: 'Washington', country: 'United States' },
  { name: 'East', street: '10215 Manitou Beach Dr NE', city: 'Bainbridge Island', state: 'Washington', country: 'United States' }
]
zones.each {|z| Zone.create(name: z[:name], street: z[:street], city: z[:city], state: z[:state], country: z[:country] )}


(1..15).each do
  Driver.create(name: Faker::Name.name, zone_id: rand(5) +1, email: Faker::Internet.email, phone: Faker::PhoneNumber.cell_phone)
end

routes = [
{ name: 'Battle Point', street: '9091 Olympus Beach Rd NE', zone: 'West' },
{ name: 'Bloedel Reserve', street:'16253 Agate Point Rd NE', zone: 'West' },
{ name: 'Eagledale', street: '10837 Bill Point Bluff NE', zone: 'South' },
{ name: 'Ferncliff', street: '1017 Aaron Ave NE', zone: 'East' },
{ name: 'Fort Ward', street: '1747 Parade Grounds Ave NE', zone: 'South' },
{ name: 'High School', street: '9458 Capstan Dr NE', zone: 'Center' },
{ name: 'Meadowmeer', street: '8458 NE Meadowmeer Dr', zone: 'West' },
{ name: 'New Brooklyn', street: '8245 New Holland Ct', zone: 'West' },
{ name: 'Point White', street: '3154 Point White Dr NE', zone: 'South' },
{ name: 'Port Blakely', street: '4699 NE Mill Heights Cir', zone: 'South' },
{ name: 'Rolling Bay', street: '10799 Manitou Beach Dr NE', zone: 'East' },
{ name: 'Wing Point', street: '8477 Ferncliff Ave NE', zone: 'East' },
{ name: 'Winslow North', street: '657 Annie Rose Ln NW', zone: 'Center' },
{ name: 'Winslow South', street: '400 Harborview Dr SE', zone: 'Center' }
]


routes.each do |route|
  zone = Zone.where(name: route[:zone]).first
  Route.create(name: route[:name], street: route[:street], zone_id: zone.id)
end


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

streets[0..25].each do |s|
  reservation = build(:reservation)
  Reservation.create(name: reservation.name, street: s, email: reservation.email, status: :pending_pickup)
end
