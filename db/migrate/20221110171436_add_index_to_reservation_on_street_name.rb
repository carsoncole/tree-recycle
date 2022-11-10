class AddIndexToReservationOnStreetName < ActiveRecord::Migration[7.0]
  def change
    add_index :reservations, [:street_name, :house_number]
  end
end
