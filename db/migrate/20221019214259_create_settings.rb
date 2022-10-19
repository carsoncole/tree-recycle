class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :organization_name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.text :description
      t.date :pickup_date

      t.timestamps
    end
  end
end
