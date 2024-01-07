desc 'archive all event day and reset in preparation for next event'

namespace :post_event do

  task :reset_and_archive_data => :environment do
    Reservation.process_post_event_reservations!

    Log.destroy_all
    Donation.destroy_all
    Message.destroy_all
  end
end
