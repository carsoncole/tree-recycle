class AddHouseNumberToRoutes < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :house_number, :string
    add_column :routes, :street_name, :string
  end
end
