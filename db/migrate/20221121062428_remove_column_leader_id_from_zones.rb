class RemoveColumnLeaderIdFromZones < ActiveRecord::Migration[7.0]
  def change
    remove_column :zones, :leader_id, :bigint
  end
end
