class RemoveColumnsIsCashOrCheck < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :is_cash_or_check, :boolean
  end
end
