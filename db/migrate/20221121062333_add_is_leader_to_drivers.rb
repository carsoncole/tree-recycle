class AddIsLeaderToDrivers < ActiveRecord::Migration[7.0]
  def change
    add_column :drivers, :is_leader, :boolean
  end
end
