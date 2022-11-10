class RenameDistanceToZoneToDistanceToRouteInReservations < ActiveRecord::Migration[7.0]
  def change
    rename_column :reservations, :distance_to_zone, :distance_to_route
  end
end
