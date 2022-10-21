class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :reservations, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :street_1
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :notes
      t.decimal :latitude
      t.decimal :longitude
      t.boolean :picked_up

      t.timestamps
    end
  end
end
