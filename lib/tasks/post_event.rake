desc 'send marketing emails to last years tree reservations'

namespace :post_event do

  task :archive_data => :environment do
    # destroy unconfirmed
    Reservation.unconfirmed.destroy_all
    Rails.logger.info "Destroyed unconfirmed reservations."

    # destroy unsubscribed
    Reservation.archived.where(no_emails: true).destroy_all
    Rails.logger.info "Destroyed archived emails that unsubscribed."

    # merge records, deleting older duplicate archived records
    Reservation.merge_unarchived_with_archived!
    Rails.logger.info "Archived all data."

    # disable geocoding / routing
    Reservation.update_all(is_geocoded: false, is_routed: false)
  end

end
