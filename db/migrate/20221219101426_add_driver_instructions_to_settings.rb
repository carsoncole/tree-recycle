class AddDriverInstructionsToSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :driver_instructions, :text
  end
end
