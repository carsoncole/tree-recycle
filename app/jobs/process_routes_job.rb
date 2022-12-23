class ProcessRoutesJob < ApplicationJob
  queue_as :urgent

  def perform
    Reservation.process_all_routes!
  end
end
