class CreateDriverRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :driver_routes do |t|
      t.references :driver
      t.references :route

      t.timestamps
    end
  end
end
