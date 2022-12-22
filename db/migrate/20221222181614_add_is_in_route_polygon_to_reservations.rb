class AddIsInRoutePolygonToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_route_polygon, :boolean, default: false
  end
end
