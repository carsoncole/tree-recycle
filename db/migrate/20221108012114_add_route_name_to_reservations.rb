class AddRouteNameToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :route_name, :string
  end
end
