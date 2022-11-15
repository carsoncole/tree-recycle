class AddIsRoutedToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_routed, :boolean, default: true
  end
end
