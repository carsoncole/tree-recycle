class AddIndexOnEmailStatusToReservations < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, [:status, :email]
  end
end
