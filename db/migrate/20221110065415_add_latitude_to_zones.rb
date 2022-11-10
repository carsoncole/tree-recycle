class AddLatitudeToZones < ActiveRecord::Migration[7.0]
  def change
    add_column :zones, :street, :string
    add_column :zones, :city, :string
    add_column :zones, :state, :string
    add_column :zones, :country, :string
    add_column :zones, :latitude, :decimal
    add_column :zones, :longitude, :decimal
  end
end
