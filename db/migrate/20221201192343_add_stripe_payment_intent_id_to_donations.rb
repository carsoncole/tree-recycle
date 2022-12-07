class AddStripePaymentIntentIdToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :stripe_payment_intent_id, :string
    add_column :donations, :customer_name, :string
    add_column :donations, :checkout_session_status, :string
    add_column :donations, :checkout_session_customer_email, :string
  end
end
