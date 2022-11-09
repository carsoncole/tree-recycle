class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|

      t.string :name
      t.string :phone
      t.string :email
      t.references :team

      t.timestamps
    end
  end
end
