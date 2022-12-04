class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :number
      t.string :body
      t.uuid :reservation_id
      t.string :service_status
      t.integer :direction
      t.boolean :viewed, default: false

      t.timestamps
    end
  end
end
