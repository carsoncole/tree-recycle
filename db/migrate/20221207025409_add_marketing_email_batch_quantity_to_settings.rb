class AddMarketingEmailBatchQuantityToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :email_batch_quantity, :integer, default: 300
  end
end
