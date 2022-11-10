class AddIndexToDriversOnZoneId < ActiveRecord::Migration[7.0]
  def change
    add_index :drivers, :zone_id
  end
end
