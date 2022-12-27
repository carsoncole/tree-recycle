class RemoveColumnDefaultCityFromReservations < ActiveRecord::Migration[7.0]
  def change
    remove_column :settings, :default_city, :string
    remove_column :settings, :default_state, :string
    remove_column :settings, :default_country, :string
  end
end
