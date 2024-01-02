class AddCategoryToLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :logs, :category, :integer, default: 1, null: false
  end
end
