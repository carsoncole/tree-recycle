class AddIsDoorhangerToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_door_hanger, :boolean
    add_column :reservations, :collected, :integer
    add_column :reservations, :collected_amount, :decimal
  end
end
