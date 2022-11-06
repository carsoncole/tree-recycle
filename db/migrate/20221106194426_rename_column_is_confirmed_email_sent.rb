class RenameColumnIsConfirmedEmailSent < ActiveRecord::Migration[7.0]
  def change
    rename_column :reservations, :is_confirmation_email_sent, :is_confirmed_reservation_email_sent
    rename_column :reservations, :is_reminder_email_sent, :is_pick_up_reminder_email_sent
  end
end
