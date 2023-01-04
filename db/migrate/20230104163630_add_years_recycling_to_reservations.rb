class AddYearsRecyclingToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :years_recycling, :integer, default: 1
  end
end
