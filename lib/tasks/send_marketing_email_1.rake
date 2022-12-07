desc 'send marketing emails to last years tree reservations'

namespace :marketing do

  # these marketing emails will not send to reservations with { no_emails: true }

  # send emails to archived reservations that don't have new reservations with same email or log indicating already sent
  task :send_email_1_to_archived_customers => :environment do
    puts "\n== Preparing Email 1 for delivery =="
    puts "\n Batch size: #{ Setting.first.email_batch_quantity }"

    # collect Archived,
    #    not in not_archived
    #    not sent marketing email 1
    #    not no_emails
    #    max count of email_batch_quantity
    reservations_to_send =
      Reservation.archived.
      where.not(email:  Reservation.not_archived.map{ |r| r.email } ).
      where.not(is_marketing_email_1_sent: true).
      where.not(no_emails: true).
      limit(Setting.first.email_batch_quantity)

    # removes dupes
    reservations_to_send = reservations_to_send.uniq { |r| r.email }

    # send the emails
    puts "\n== Sending for delivery =="
    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_1.deliver_later }
    puts "\n== #{reservations_to_send.count} emails queued =="
  end

  # send emails to archived reservations that don't have new reservations with same email or log indicating already sent
  task :send_email_2_to_archived_customers => :environment do
    puts "\n== Preparing Email 2 for delivery =="
    puts "\n Batch size: #{ Setting.first.email_batch_quantity }"
    reservations_to_send = Reservation.archived.where.not(email:  Reservation.not_archived.map{ |r| r.email } ).where.not(is_marketing_email_2_sent: true).limit(Setting.first.email_batch_quantity) #only archived without current yr reservations
    reservations_to_send = reservations_to_send.uniq { |r| r.email } # remove dupes
    puts "\n== Sending for delivery =="
    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_2.deliver_later }
    puts "\n== #{reservations_to_send.count} emails queued =="
  end
end
