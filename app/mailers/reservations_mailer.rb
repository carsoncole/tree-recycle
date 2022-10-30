class ReservationsMailer < ApplicationMailer
  after_action :stop_delivery_if_disabled

  def stop_delivery_if_disabled
    unless Setting&.first&.is_emailing_enabled
      puts "****** Emailing DISABLED *******"
      mail.perform_deliveries = false
    end
  end

  def confirmed_reservation_email
    @reservation = params[:reservation]
    mail(to: @reservation.email, subject: 'Your tree pickup is confirmed')
  end

  def pick_up_reminder_email
    @reservation = params[:reservation]
    mail(to: @reservation.email, subject: 'Reminder to put out your tree')
  end
end
