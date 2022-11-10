class RenameZoneIdToRouteId < ActiveRecord::Migration[7.0]
  def up
    remove_index :reservations, column: :zone_id
    rename_column :reservations, :zone_id, :route_id
    add_index :reservations, :route_id
  end

  def down
    remove_index :reservations, :route_id
    rename_column :reservations, :route_id, :zone_id
    add_index :reservations, :zone_id
  end
end
