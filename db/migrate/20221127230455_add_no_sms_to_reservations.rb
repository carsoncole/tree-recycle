class AddNoSmsToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :no_sms, :boolean
  end
end
