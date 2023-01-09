class AddNoteToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :note, :string
  end
end
