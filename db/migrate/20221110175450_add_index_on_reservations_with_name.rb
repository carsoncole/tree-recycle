class AddIndexOnReservationsWithName < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, :name
    add_index :reservations, :street
  end
end
