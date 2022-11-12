# Application and event day defaults, and hosting organization information is stored in the first record of this model.
class Setting < ApplicationRecord
  attribute :site_title, :string, default: 'Tree Recycle'
  attribute :organization_name, :string, default: 'Troop 100'
  attribute :default_city, :string, default: 'Bainbridge Island'
  attribute :default_state, :string, default: 'Washington'
  attribute :default_country, :string, default: 'United States'
  attribute :pickup_date_and_time, :datetime, default: -> { Time.now + 1.month }
  attribute :sign_up_deadline_at, :datetime, default: -> { Time.now + 1.month - 1.day }
  attribute :contact_name, :string, default: 'John Doe'
  attribute :contact_email, :string, default: 'john@example.com'
  attribute :contact_phone, :string, default: '206-555-1212'
  attribute :on_day_of_pickup_instructions, :string, default: 'Pickup day instructions...'
end
