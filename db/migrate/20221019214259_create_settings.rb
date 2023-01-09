class CreateSettings < ActiveRecord::Migration[7.0]
  def up
    create_table :settings do |t|
      t.string :site_title
      t.text :site_description
      t.string :organization_name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.text :description
      t.text :on_day_of_pickup_instructions
      t.boolean :is_reservations_open, default: true
      t.boolean :is_emailing_enabled, default: false
      t.datetime :pickup_date_and_time
      t.string :default_city
      t.string :default_state
      t.string :default_country, default: 'United States'

      t.timestamps
    end
    Setting.create  site_description: 'Our Tree Recycle event is to fundraise that will support our program.',
                    description: 'Our tree recycling event is an important fundraiser for Troop 100 and all donations go towards our program and directly supporting Scouts. On the recycle date, we will come to your house, pick-up your Christmas tree, and recycle it into compost. Thank you for your support',
                    on_day_of_pickup_instructions: 'To prepare your tree for pick-up, remove all decorations and tinsel from your tree. On the day of pickup, place your tree in a visible location at the curb. Your tree will be collected and recycled into mulch. We cannot take wreaths, flocked trees, or artificial trees.',
                    organization_name: 'Troop 100',
                    contact_name: 'John Doe',
                    contact_email: 'john.doe@example.com',
                    contact_phone: '206-555-1212',
                    default_city: 'Bainbridge Island',
                    default_state: 'Washington',
                    default_country: 'United States'
  end

  def down
    drop_table :settings
  end
end
