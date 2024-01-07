class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.uuid :reservation_id, null: false
      t.date :date

      t.timestamps
    end
  end
end
