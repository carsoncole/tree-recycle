class AddIndexToRoutesOnName < ActiveRecord::Migration[7.0]
  def change
    add_index :routes, :name
    add_index :zones, :name
  end
end
