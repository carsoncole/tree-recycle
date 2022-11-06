#OPTIMIZE is there a way to eliminate duplicate emails in archive?
class ReservationsMailer < ApplicationMailer
  include ApplicationHelper
  after_action :stop_delivery_if_disabled

  def stop_delivery_if_disabled
    unless setting.is_emailing_enabled
      mail.perform_deliveries = false
    end
  end

  def confirmed_reservation_email
    @reservation = params[:reservation]
    return if @reservation.is_confirmed_reservation_email_sent
    mail(to: @reservation.email, subject: 'Your tree pickup is confirmed')
    @reservation.update(is_confirmed_reservation_email_sent: true) if setting.is_emailing_enabled
  end

  def pick_up_reminder_email
    @reservation = params[:reservation]
    return if @reservation.is_pick_up_reminder_email_sent
    mail(to: @reservation.email, subject: 'Reminder to put out your tree')
    @reservation.update(is_pick_up_reminder_email_sent: true) if setting.is_emailing_enabled
  end

  # email to prior year reservations
  def hello_email
    @reservation = params[:reservation]
    return if @reservation.is_hello_email_sent && !@reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling on #{nice_long_date(setting.pickup_date_and_time)}")
    @reservation.update(is_hello_email_sent: true) if setting.is_emailing_enabled
  end

  # email last reminder to prior year reservations
  def last_call_email
    @reservation = params[:reservation]
    return if @reservation.is_last_call_email_sent && !@reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling last reminder for #{nice_long_date(setting.pickup_date_and_time)}")
    @reservation.update(is_last_call_email_sent: true) if setting.is_emailing_enabled
  end

  #OPTIMIZE should we record sending of this email?
  def cancelled_reservation_email
    @reservation = params[:reservation]
    return if @reservation.archived?
    mail(to: @reservation.email, subject: "Your tree pickup reservation is cancelled")
  end
end
