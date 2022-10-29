class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :site_title
      t.text :site_description
      t.string :organization_name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.text :description
      t.datetime :pickup_date_and_time
      t.string :default_city
      t.string :default_state
      t.string :default_country

      t.timestamps
    end
  end
end
