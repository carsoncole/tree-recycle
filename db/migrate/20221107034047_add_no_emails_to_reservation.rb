class AddNoEmailsToReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :no_emails, :boolean
  end
end
