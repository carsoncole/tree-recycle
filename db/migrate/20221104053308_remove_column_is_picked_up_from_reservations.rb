class RemoveColumnIsPickedUpFromReservations < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :is_picked_up, :boolean
    remove_column :reservations, :picked_up_at, :datetime
    remove_column :reservations, :is_missing, :boolean
    remove_column :reservations, :is_missing_at, :datetime
    remove_column :reservations, :is_cancelled, :boolean
    remove_column :reservations, :is_confirmed, :boolean
  end
end
