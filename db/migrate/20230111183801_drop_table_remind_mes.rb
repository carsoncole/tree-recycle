class DropTableRemindMes < ActiveRecord::Migration[7.0]
  def change
    drop_table :remind_mes
  end
end
