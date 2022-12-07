class AddDefaultNoEmailOnReservations < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reservations, :no_emails, from: nil, to: false
    change_column_default :reservations, :no_sms, from: nil, to: false
  end
end
