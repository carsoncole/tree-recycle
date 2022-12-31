class AddFormToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :form, :integer
  end
end
