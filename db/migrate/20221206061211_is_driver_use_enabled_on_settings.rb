class IsDriverUseEnabledOnSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :is_driver_site_enabled, :boolean, default: true
  end
end
