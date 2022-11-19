class AddIndexToReservationsOnStatusAndRouteId < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, [:status, :route_id]
  end
end
