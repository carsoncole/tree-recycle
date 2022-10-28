class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :reservations, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :street
      t.string :house_number
      t.string :street_name
      t.string :city
      t.string :state
      t.string :zip
      t.string :country, default: 'United States'
      t.string :notes
      t.boolean :is_completed
      t.boolean :is_donated
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :picked_up_at
      t.references :zone
      t.decimal :distance_to_zone

      t.timestamps
    end
  end
end
