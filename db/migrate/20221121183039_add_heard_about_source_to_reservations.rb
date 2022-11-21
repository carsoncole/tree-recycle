class AddHeardAboutSourceToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :heard_about_source, :integer
  end
end
