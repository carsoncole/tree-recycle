class AddIsHelloEmailSentToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_hello_email_sent, :boolean
    add_column :reservations, :is_last_call_email_sent, :boolean
  end
end
