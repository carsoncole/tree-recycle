#OPTIMIZE is there a way to eliminate duplicate emails in archive?
class ReservationsMailer < ApplicationMailer
  include ApplicationHelper
  before_action :set_reservation
  after_action :stop_delivery_if_disabled

  def set_reservation
    @reservation = params[:reservation]
  end

  def stop_delivery_if_disabled
    if !setting.is_emailing_enabled && @reservation.no_emails
      mail.perform_deliveries = false
    end
  end

  def confirmed_reservation_email
    mail(to: @reservation.email, subject: 'Your tree pickup is confirmed')
    @reservation.logs.create(message: 'Confirmed reservation email sent.')
  end

  def pick_up_reminder_email
    mail(to: @reservation.email, subject: 'Reminder to put out your tree')
    @reservation.logs.create(message: 'Pick up reminder email sent.')
  end

  # email to prior year reservations
  def hello_email
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling on #{nice_long_date(setting.pickup_date_and_time)}")
    @reservation.logs.create(message: 'Hello email sent.')
  end

  # email last reminder to prior year reservations
  def last_call_email
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling last reminder for #{nice_long_date(setting.pickup_date_and_time)}")
    @reservation.logs.create(message: 'Last call email sent.')
  end

  #OPTIMIZE should we record sending of this email?
  def cancelled_reservation_email
    mail(to: @reservation.email, subject: "Your tree pickup reservation is cancelled")
    @reservation.logs.create(message: 'Cancelled reservation email sent.')
  end
end
