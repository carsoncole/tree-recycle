class AddIndexPhoneOnReservations < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, [:phone, :status]
    add_index :messages, :phone
  end
end
