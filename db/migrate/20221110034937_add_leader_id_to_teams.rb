class AddLeaderIdToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :leader_id, :bigint
  end
end
