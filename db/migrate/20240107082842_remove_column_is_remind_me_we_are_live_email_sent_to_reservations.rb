class RemoveColumnIsRemindMeWeAreLiveEmailSentToReservations < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :is_remind_me_we_are_live_email_sent, :boolean
  end
end
