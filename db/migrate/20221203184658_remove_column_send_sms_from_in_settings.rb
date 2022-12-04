class RemoveColumnSendSmsFromInSettings < ActiveRecord::Migration[7.0]
  def change
    remove_column :settings, :sms_from_phone, :string
  end
end
