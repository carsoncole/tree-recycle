class AddIsPickupReminderEmailSentToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_pickup_reminder_email_sent, :boolean, default: false
  end
end
