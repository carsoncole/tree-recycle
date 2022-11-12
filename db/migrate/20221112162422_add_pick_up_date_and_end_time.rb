class AddPickUpDateAndEndTime < ActiveRecord::Migration[7.0]
  def change
    add_column :settings, :pickup_date_and_end_time, :datetime
  end
end
