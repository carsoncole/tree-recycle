class RenameTableTeamsZones < ActiveRecord::Migration[7.0]
  def change
    rename_table :teams, :zones
    remove_index :drivers, column: :team_id
    rename_column :drivers, :team_id, :zone_id
  end
end
