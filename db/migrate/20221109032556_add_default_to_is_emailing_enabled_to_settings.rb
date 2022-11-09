class AddDefaultToIsEmailingEnabledToSettings < ActiveRecord::Migration[7.0]
  def change
    change_column :settings, :is_emailing_enabled, :boolean, :default => true
  end
end
