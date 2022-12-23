drequire 'faker'
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

high_school_points = [
  [47.64665, -122.52186],
  [47.64672, -122.52665],
  [47.64312, -122.52866],
  [47.63833, -122.53288],
  [47.63596, -122.53418],
  [47.63589, -122.52110],
  [47.63834, -122.52104],
  [47.63825, -122.51515],
  [47.64027, -122.51564],
  [47.64271, -122.51753],
  [47.64666, -122.52180]
]

sunrise_points = [
  [47.70953, -122.50730, 1],
  [47.70877, -122.51870, 2],
  [47.70439, -122.52207, 3],
  [47.70381, -122.52206, 4],
  [47.70278, -122.51864, 5],
  [47.69486, -122.51790, 6],
  [47.69369, -122.51540, 7],
  [47.69199, -122.51610, 8],
  [47.69171, -122.51840, 9],
  [47.68581, -122.51792, 10],
  [47.68505, -122.51563, 11],
  [47.68123, -122.51752, 12],
  [47.67967, -122.51642, 13],
  [47.67681, -122.51881, 14],
  [47.67051, -122.51840, 15],
  [47.67027, -122.51512, 16],
  [47.66655, -122.51899, 17],
  [47.66657, -122.50987, 18],
  [47.66826, -122.50956, 19],
  [47.66846, -122.50736, 20],
  [47.70299, -122.49954, 21]
]

phelps_points = [
[47.71048, -122.52784],
[47.69821, -122.53030],
[47.69642, -122.54243],
[47.69160, -122.54945],
[47.69080, -122.55120],
[47.67498, -122.53460],
[47.67635, -122.52161],
[47.67549, -122.51848],
[47.67848, -122.51836],
[47.68010, -122.51664],
[47.69364, -122.51560],
[47.69746, -122.52040],
[47.70212, -122.51879],
[47.70429, -122.52230],
[47.70514, -122.52130],
[47.70769, -122.52082]
]

bloedel = [
[47.72595, -122.54922, 1],
[47.70453, -122.57008,2],
[47.70472, -122.55961,3],
[47.70104, -122.55751,4],
[47.69337, -122.55388,5],
[47.69064, -122.55111,6],
[47.69397, -122.54589,7],
[47.69774, -122.53849,8],
[47.70045, -122.52912,9],
[47.71460, -122.52920, 10]
]

new_brooklyn_points = [
[47.66425, -122.55684],
[47.64872, -122.56485],
[47.64704, -122.56117],
[47.64142, -122.56360],
[47.64117, -122.55401],
[47.63831, -122.55332],
[47.63588, -122.55756],
[47.62622, -122.53946],
[47.62935, -122.53464],
[47.63656, -122.53376],
[47.64209, -122.53030],
[47.64669, -122.52657],
[47.64672, -122.52217],
[47.64956, -122.52303],
[47.65526, -122.52340],
[47.65993, -122.53252],
[47.65976, -122.54224],
[47.65389, -122.55040],
[47.65448, -122.55722],
[47.66371, -122.55709]
]

battlepoint_points = [
[47.67582, -122.56753, 1],
[47.67608, -122.57381, 2],
[47.66408, -122.59544, 3],
[47.64387, -122.58140, 4],
[47.64438, -122.57402, 5],
[47.64598, -122.57250, 6],
[47.64759, -122.56910, 7],
[47.64823, -122.56555, 8],
[47.65173, -122.56336, 9],
[47.65704, -122.56064, 10],
[47.66029, -122.55874, 11],
[47.66363, -122.55736, 12],
[47.66351, -122.56179, 13],
[47.66364, -122.56858, 14]
]

winslow_north = [
[47.63870, 122.51532, 1],
[47.63880, 122.52095, 2],
[47.63584, 122.52108, 3],
[47.63583, 122.52629, 4],
[47.63488, 122.52690, 5],
[47.63483, 122.52905, 6],
[47.62859, 122.52904, 7],
[47.62852, 122.51588, 8],
[47.63574, 122.51555, 9]
]

winslow_south = [
[47.63137, -122.51511, 1],
[47.62856, -122.51590, 2],
[47.62851, -122.52639, 3],
[47.62677, -122.52639, 4],
[47.62430, -122.53031, 5],
[47.61901, -122.52642, 6],
[47.61947, -122.51178, 7],
[47.62302, -122.50825, 8],
[47.62484, -122.51390, 9],
[47.62840, -122.51502, 10],
[47.62964, -122.51319, 11],
[47.63113, -122.51393, 12]
]

wing_point = [
[47.65354, -122.52305, 1],
[47.64782, -122.52266, 2],
[47.63941, -122.51547, 3],
[47.63932, -122.51030, 4],
[47.63802, -122.50615, 5],
[47.63784, -122.50540, 6],
[47.63683, -122.50385, 7],
[47.63332, -122.49720, 8],
[47.63208, -122.49699, 9],
[47.63203, -122.49605, 10],
[47.62837, -122.49619, 11],
[47.62846, -122.50318, 12],
[47.62842, -122.51034, 13],
[47.62890, -122.51268, 14],
[47.62880, -122.51401, 15],
[47.62808, -122.51496, 16],
[47.62623, -122.51420, 17],
[47.62481, -122.51384, 18],
[47.62281, -122.50934, 19],
[47.61990, -122.49110, 20],
[47.63379, -122.48674, 21],
[47.65201, -122.51464, 22],
[47.65059, -122.51985, 23]
]

ferncliff = [
[47.63945, -122.51552, 1],
[47.63780, -122.51521, 2],
[47.63160, -122.51566, 3],
[47.63089, -122.51355, 4],
[47.62937, -122.51336, 5],
[47.62862, -122.51199, 6],
[47.62851, -122.50839, 7],
[47.62847, -122.49982, 8],
[47.62837, -122.49624, 9],
[47.62972, -122.49606, 10],
[47.63207, -122.49611, 11],
[47.63207, -122.49716, 12],
[47.63339, -122.49746, 13],
[47.63582, -122.50187, 14],
[47.63787, -122.50533, 15],
[47.63912, -122.50903, 16],
[47.63972, -122.51032, 17],
[47.63940, -122.51317, 18],
[47.63953, -122.51501, 19]
]

rolling_bay = [
[47.66667, -122.52771, 1],
[47.66040, -122.52390, 2],
[47.65735, -122.52322, 3],
[47.65368, -122.52273, 4],
[47.65041, -122.51950, 5],
[47.66169, -122.49631, 6],
[47.66836, -122.50754, 7],
[47.66826, -122.50951, 8],
[47.66653, -122.50979, 9],
[47.66693, -122.51777, 10],
[47.66540, -122.52029, 11],
[47.66497, -122.52301, 12],
[47.66632, -122.52701, 13]
]

lovgren = [
[47.67698, -122.51866, 1],
[47.67692, -122.52171, 2],
[47.67626, -122.52275, 3],
[47.67421, -122.53379, 4],
[47.66898, -122.52984, 5],
[47.66868, -122.52612, 6],
[47.66481, -122.52545, 7],
[47.66477, -122.52073, 8],
[47.66543, -122.52034, 9],
[47.66592, -122.51916, 10],
[47.67485, -122.51870, 11],
[47.67605, -122.51830, 12]
]

blakely = [
[47.62780, -122.54209,1],
[47.62579, -122.54161,2],
[47.62235, -122.54253,4],
[47.62148, -122.54228,5],
[47.62148, -122.54133,6],
[47.61028, -122.53645,7],
[47.59868, -122.52798,9],
[47.59713, -122.51864,11],
[47.59514, -122.50961,13],
[47.59659, -122.50018,14],
[47.60740, -122.50114,16],
[47.60929, -122.50860,17],
[47.60924, -122.51184,18],
[47.60891, -122.51941,20],
[47.60600, -122.51989,21],
[47.60600, -122.52429,23],
[47.60733, -122.52538,24],
[47.61040, -122.52538,25],
[47.61128, -122.52896,26],
[47.61355, -122.52962,27],
[47.61540, -122.53389,29],
[47.62108, -122.53745,31],
[47.62206, -122.53909,33],
[47.62249, -122.53932,35],
[47.62383, -122.53890,37],
[47.62593, -122.54057,40]

]


eagledale = [
[47.62660, -122.54022, 1],
[47.62263, -122.53917, 3],
[47.62159, -122.53902, 4],
[47.61981, -122.53519, 5],
[47.61397, -122.53168, 6],
[47.61280, -122.52873, 8],
[47.61103, -122.52850, 9],
[47.61000, -122.52434, 11],
[47.60578, -122.52305, 12],
[47.60612, -122.52025, 14],
[47.60944, -122.51894, 15],
[47.60957, -122.51274, 16],
[47.60744, -122.50746, 19],
[47.60708, -122.50112, 22],
[47.59649, -122.49928, 24],
[47.59716, -122.49652, 25],
[47.61895, -122.49767, 26],
[47.61939, -122.52611, 29],
[47.62392, -122.53095, 31],
[47.62519, -122.53786, 33]

]


meadowmeer = [
[47.67649, -122.56467,1],
[47.66396, -122.56830,4],
[47.66290, -122.56381,5],
[47.66362, -122.56068,6],
[47.66358, -122.55720,7],
[47.65903, -122.55384,9],
[47.65431, -122.55369,11],
[47.65444, -122.54373,12],
[47.65997, -122.53902,13],
[47.66007, -122.52933,14],
[47.65426, -122.52220,16],
[47.66066, -122.52404,18],
[47.66668, -122.52795,20],
[47.66699, -122.52599,22],
[47.67039, -122.52687,25],
[47.67060, -122.53097,27],
[47.67111, -122.54852,29],
[47.67060, -122.54883,30],
[47.67063, -122.55149,31],
[47.66850, -122.55402,33],
[47.67251, -122.55458,35],
[47.67272, -122.55764,36]

]


fletcher= [
[47.64861, -122.56240, 1],
[47.64796, -122.56743, 3],
[47.64723, -122.57013, 4],
[47.64556, -122.57292, 6],
[47.64402, -122.57682, 7],
[47.64368, -122.57980, 9],
[47.62860, -122.57937, 10],
[47.62889, -122.56383, 12],
[47.63656, -122.56410, 14],
[47.64264, -122.56831, 15],
[47.64305, -122.56465, 17],
[47.64328, -122.56367, 18],
[47.64634, -122.56323, 20],
[47.64676, -122.56115, 22],
[47.64861, -122.56124, 24]

]



ldovgren = [
[],
[],
[],
[],
[],
[],
[],
[],
[],
[],
[],
[],
[],
[],
[],
[],

]



route = Route.find(23)
fletcher.each do |lat, lon, order|
 route.points.create(latitude: lat, longitude: lon, order: order)
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
