class AddIsRemindMesEnabledToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :is_remind_mes_enabled, :boolean, default: false
  end
end
