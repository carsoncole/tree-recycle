class RemoveIsHelloEmailSentFromReservations < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :is_hello_email_sent, :boolean
    remove_column :reservations, :is_last_call_email_sent, :boolean
    remove_column :reservations, :is_confirmed_reservation_email_sent, :boolean
    remove_column :reservations, :is_pick_up_reminder_email_sent, :boolean
  end
end
