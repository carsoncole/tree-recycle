class AddDriverSecretKeyToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :driver_secret_key, :string
  end
end
