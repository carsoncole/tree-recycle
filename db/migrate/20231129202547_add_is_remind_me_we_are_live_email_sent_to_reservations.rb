class AddIsRemindMeWeAreLiveEmailSentToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_remind_me_we_are_live_email_sent, :boolean, default: false
  end
end
