class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.references :reservation, type: :uuid, foreign_key: true
      t.string :checkout_session_id
      t.decimal :amount, default: 0
      t.string :status
      t.string :payment_status
      t.string :receipt_url
      t.string :email
      t.boolean :is_receipt_email_sent
      t.timestamps
    end
  end
end
