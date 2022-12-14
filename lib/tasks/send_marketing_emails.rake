desc 'send marketing emails to last years tree reservations'

namespace :marketing do

  # these marketing emails will not send to reservations with { no_emails: true }

  # send emails to archived reservations that don't have new reservations with same email or log indicating already sent
  task :send_email_1_to_archived_customers => :environment do
    Rails.logger.info 'Starting task to send marketing email 1'

    reservations_to_send = Reservation.reservations_to_send_marketing_emails('is_marketing_email_1_sent')
    Rails.logger.info "Total eligible emails to send to: #{ reservations_to_send.count }"

    reservations_to_send = reservations_to_send.limit(Setting.first.email_batch_quantity)

    #removes dupes
    reservations_to_send = reservations_to_send.uniq { |r| r.email }

    # send the emails
    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_1.deliver_later }
    Rails.logger.info "#{reservations_to_send.count} emails have been queued to send"
  end

  # send emails to archived reservations that don't have new reservations with same email or log indicating already sent
  task :send_email_2_to_archived_customers => :environment do
    Rails.logger.info 'Starting task to send marketing email 2'

    reservations_to_send = Reservation.reservations_to_send_marketing_emails('is_marketing_email_2_sent')
    Rails.logger.info "Total eligible emails to send to: #{ reservations_to_send.count }"

    reservations_to_send = reservations_to_send.limit(Setting.first.email_batch_quantity)

    #removes dupes
    reservations_to_send = reservations_to_send.uniq { |r| r.email }

    # send the emails
    reservations_to_send.each { |r| MarketingMailer.with(reservation: r).marketing_email_2.deliver_later }
    Rails.logger.info "#{reservations_to_send.count} emails have been queued to send"
  end
end
