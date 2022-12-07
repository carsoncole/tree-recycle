#OPTIMIZE create mailer for unconfirmed reservations
#OPTIMIZE is there a way to eliminate duplicate emails in archive?
class ReservationsMailer < ApplicationMailer
  include ApplicationHelper
  before_action :set_reservation
  after_action :stop_delivery_if_disabled

  def set_reservation
    @reservation = params[:reservation]
  end

  # redundant, but is a safety check
  def stop_delivery_if_disabled
    if !setting.is_emailing_enabled? || @reservation&.no_emails?
      mail.perform_deliveries = false
    end
  end

  def confirmed_reservation_email
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return if @reservation.is_confirmed_reservation_email_sent?
    mail(to: @reservation.email, subject: 'Your tree pickup is confirmed')
    @reservation.logs.create(message: 'Confirmed reservation email sent.')
    @reservation.update(is_confirmed_reservation_email_sent: true)
  end

  def pick_up_reminder_email
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    mail(to: @reservation.email, subject: 'Reminder to put out your tree')
    @reservation.logs.create(message: 'Pick up reminder email sent.')
  end

  def cancelled_reservation_email
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    mail(to: @reservation.email, subject: "Your tree pickup reservation has been cancelled")
    @reservation.logs.create(message: 'Cancelled reservation email sent.')
  end
end
