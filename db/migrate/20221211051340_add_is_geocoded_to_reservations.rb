class AddIsGeocodedToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_geocoded, :boolean, default: true
  end
end
