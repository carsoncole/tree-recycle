class AddHouseNumberToZone < ActiveRecord::Migration[7.0]
  def change
    add_column :zones, :house_number, :string
    add_column :zones, :street_name, :string
  end
end
