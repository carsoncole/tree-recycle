class RenameColumnNumberToPhoneOnMessages < ActiveRecord::Migration[7.0]
  def change
    rename_column :messages, :number, :phone
  end
end
