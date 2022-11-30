class AddDonationToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :donation, :integer
  end
end
