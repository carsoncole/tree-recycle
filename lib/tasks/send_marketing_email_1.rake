desc 'send marketing emails to last years tree reservations'

namespace :marketing do

  # these marketing emails will not send to reservations with { no_emails: true }

  # send emails to archived reservations that don't have new reservations with same email or log indicating already sent
  task :send_email_1_to_archived_customers => :environment do
    puts "\n== Preparing Email 1 for delivery =="
    puts "\n Batch size: #{ Setting.first.email_batch_quantity }"

    reservations_to_send = Reservation.reservations_to_send_marketing
    puts "Total available size: #{ reservations_to_send.count }"

    reservations_to_send = reservations_to_send.limit(Setting.first.email_batch_quantity)

    #removes dupes
    reservations_to_send = reservations_to_send.uniq { |r| r.email }

    # send the emails
    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_1.deliver_later }
    puts "\n== #{reservations_to_send.count} emails queued =="
  end

  # send emails to archived reservations that don't have new reservations with same email or log indicating already sent
  task :send_email_2_to_archived_customers => :environment do
    puts "\n== Preparing Email 2 for delivery =="
    puts "\n Batch size: #{ Setting.first.email_batch_quantity }"

    reservations_to_send = Reservation.reservations_to_send_marketing
    puts "Total available size: #{ reservations_to_send.count }"

    reservations_to_send = reservations_to_send.limit(Setting.first.email_batch_quantity)

    #removes dupes
    reservations_to_send = reservations_to_send.uniq { |r| r.email }

    # send the emails
    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_2.deliver_later }
    puts "\n== #{reservations_to_send.count} emails queued =="
  end
end
