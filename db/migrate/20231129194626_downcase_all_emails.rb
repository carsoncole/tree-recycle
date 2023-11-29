class DowncaseAllEmails < ActiveRecord::Migration[7.0]
  def up
    Reservation.all.each do |reservation|
      reservation.update_columns(email: reservation.email.downcase)
    end
  end
end
