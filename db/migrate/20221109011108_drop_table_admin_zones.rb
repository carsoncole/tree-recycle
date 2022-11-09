class DropTableAdminZones < ActiveRecord::Migration[7.0]
  def change
    drop_table :admin_zones
  end
end
