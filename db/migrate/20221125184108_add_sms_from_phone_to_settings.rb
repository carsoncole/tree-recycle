class AddSmsFromPhoneToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :sms_from_phone, :string
  end
end
