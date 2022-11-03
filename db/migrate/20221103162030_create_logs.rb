class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.references :reservation, null: false, type: :uuid, foreign_key: true
      t.string :message
      t.timestamps
    end
  end
end
