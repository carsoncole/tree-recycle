class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.references :reservation, type: :uuid, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
