class CreateZones < ActiveRecord::Migration[7.0]
  def change
    create_table :zones do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.boolean :use_street_name
      t.decimal :distance
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
