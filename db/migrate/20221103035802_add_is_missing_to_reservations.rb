class AddIsMissingToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_missing, :boolean
    add_column :reservations, :is_missing_at, :datetime
  end
end
