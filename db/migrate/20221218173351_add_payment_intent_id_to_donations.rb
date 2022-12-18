class AddPaymentIntentIdToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :payment_intent_id, :string
    add_column :donations, :description, :string
    add_column :donations, :last4, :string
    add_column :donations, :exp_month, :string
    add_column :donations, :exp_year, :string
  end
end
