class RenameColumTeamIdToZoneId < ActiveRecord::Migration[7.0]
  def change
    rename_column :routes, :team_id, :zone_id
  end
end
