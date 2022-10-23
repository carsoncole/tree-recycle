class CreateAdminZones < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_zones do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :distance

      t.timestamps
    end
  end
end
