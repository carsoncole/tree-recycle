class AddAdminNotesToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :admin_notes, :string
  end
end
