class RemovedDefaultFromReservationsOnStatus < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reservations, :status, from: 0, to: nil
  end
end
