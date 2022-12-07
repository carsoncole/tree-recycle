class AddReservationsClosedMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :reservations_closed_message, :string
  end
end
