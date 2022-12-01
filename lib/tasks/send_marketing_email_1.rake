desc 'send marketing emails to last years tree reservations'

namespace :marketing do

  # these marketing emails will not send to reservations with { no_emails: true }

  # send emails to archived reservations that don't have new reservations with same email or log indicating already sent
  task :send_email_1_to_archived_customers do
    reservations_to_send = Reservation.archived.where.not(email:  Reservation.not_archived.map{ |r| r.email } ) #only archived without current yr reservations
    reservations_to_send = reservations_to_send.uniq { |r| r.email } # remove dupes
    reservations_to_send = reservations_to_send.filter_map { |r| r unless r.logs.where(message: 'Marketing email 1 sent to archived').any? }
    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_1.deliver_later }
  end

  # send emails to archived reservations that don't have new reservations with same email or log indicating already sent
  task :send_email_2_to_archived_customers do
    reservations_to_send = Reservation.archived.where.not(email:  Reservation.not_archived.map{ |r| r.email } ) #only archived without current yr reservations
    reservations_to_send = reservations_to_send.uniq { |r| r.email } # remove dupes
    reservations_to_send = reservations_to_send.filter_map { |r| r unless r.logs.where(message: 'Marketing email 2 sent to archived').any? }
    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_2.deliver_later }
  end
end
