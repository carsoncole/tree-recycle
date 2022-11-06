class AddIndexOnStatusToReservations < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, :status
  end
end
