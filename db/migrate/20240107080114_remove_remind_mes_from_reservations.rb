class RemoveRemindMesFromReservations < ActiveRecord::Migration[7.0]
  # this removes the reservation type 'remind me' which is no longer implemented
  def up
    Reservation.remind_me.destroy_all
  end
end
