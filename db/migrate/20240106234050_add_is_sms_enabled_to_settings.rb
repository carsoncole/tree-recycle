class AddIsSmsEnabledToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :is_sms_enabled, :boolean, default: false, null: false
  end
end
