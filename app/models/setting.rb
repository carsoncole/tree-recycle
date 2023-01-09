# Application and event day defaults, and hosting organization information is stored in the first record of this model.
class Setting < ApplicationRecord
  attribute :contact_name, :string, default: 'John Doe'
  attribute :contact_email, :string, default: 'john@example.com'
  attribute :contact_phone, :string, default: '206-555-1212'
  attribute :on_day_of_pickup_instructions, :string, default: 'Pickup day instructions...'
end
