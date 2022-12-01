desc 'send marketing emails to last years tree reservations'

namespace :marketing do

  task :send_email_1_to_archived_customers do
    # archived = Reservation.archived.where("email not IN ?", Reservation.)
    reservations_to_send = Reservation.archived

    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_1.deliver_later }
  end
end
