class AddIsZonedToRoutes < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :is_zoned, :boolean, default: true
  end
end
