class AddDistanceToZoneToRoutes < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :distance_to_zone, :decimal
  end
end
