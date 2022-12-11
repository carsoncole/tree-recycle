class AddDonationNotificationSmsNumberToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :donation_notification_sms_number, :string
  end
end
