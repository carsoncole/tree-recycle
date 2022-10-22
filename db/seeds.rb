User.create(email: 'admin@example.com', password: 'password')

Setting.first_or_create  do |setting|
  setting.site_title = 'Troop 100 Tree Recycle'
  setting.site_description = "This is the annual Tree Recycle fundraiser for Troop 100. Residents of Anytown, USA can have their Christmas trees recycle by making an online reservation and make an optional donation to support the Troop and it's Scouts."
  setting.contact_email = 'admin@example.com'
  setting.contact_name = 'John Doe'
  setting.pickup_date = Date.today + 1.month
  setting.organization_name = 'BSA Troop 100'
end
