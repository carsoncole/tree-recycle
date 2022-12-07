class AddIsConfirmedReservationEmailSentToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :is_confirmed_reservation_email_sent, :boolean, default: false
    add_column :reservations, :is_marketing_email_1_sent, :boolean, default: false
    add_column :reservations, :is_marketing_email_2_sent, :boolean, default: false
  end
end
