class RemoveDonationNotificationSmsNumberFromSettings < ActiveRecord::Migration[7.0]
  def change
    remove_column :settings, :donation_notification_sms_number, :string
  end
end
