desc 'send marketing emails to last years tree reservations'

namespace :post_event do

  task :archive_data => :environment do
    Reservation.process_post_event!
  end

end
