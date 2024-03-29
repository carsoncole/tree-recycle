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
    return if @reservation.is_pickup_reminder_email_sent?
    mail(to: @reservation.email, subject: 'Reminder to put out your tree')
    @reservation.logs.create(message: 'Pick up reminder email sent.')
    @reservation.update(is_pickup_reminder_email_sent: true)
  end

  def cancelled_reservation_email
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    mail(to: @reservation.email, subject: "Your tree pickup reservation has been cancelled")
    @reservation.logs.create(message: 'Cancelled reservation email sent.')
  end

  def missing_tree_email
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return if @reservation.is_missing_tree_email_sent?
    mail(to: @reservation.email, subject: "We can not find your tree")
    @reservation.logs.create(category: 'missing_tree_email', message: 'Missing tree email sent.')
    @reservation.update(is_missing_tree_email_sent: true)
  end
end
