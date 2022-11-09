class AddTeamToZones < ActiveRecord::Migration[7.0]
  def change
    add_column :zones, :team_id, :integer
  end
end
