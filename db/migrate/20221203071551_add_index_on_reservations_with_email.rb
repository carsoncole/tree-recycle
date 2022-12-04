class AddIndexOnReservationsWithEmail < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, :email
  end
end
