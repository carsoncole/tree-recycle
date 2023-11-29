class MarketingMailer < ApplicationMailer
  include ApplicationHelper
  before_action :set_reservation
  after_action :stop_delivery_if_disabled
  before_action :set_headers

  def set_reservation
    @reservation = params[:reservation]
  end

  def set_headers
    unsubscribe_url = reservation_unsubscribe_url(@reservation)
    headers['List-Unsubscribe'] = "<#{unsubscribe_url}>"
  end

  # Email to all reservations that are Remind Mes
  def remind_me_we_are_live_email
    return if @reservation.is_remind_me_we_are_live_email_sent?
    return if Reservation.pending.where(email: @reservation.email).any?
    mail(to: @reservation.email, subject: "We are now taking tree pickup reservations")
    @reservation.logs.create(message: 'Remind Me we are live email sent.')
    @reservation.update(is_remind_me_we_are_live_email_sent: true)
  end

  # redundant, but is a safety check
  def stop_delivery_if_disabled
    if !setting.is_emailing_enabled? || @reservation&.no_emails?
      mail.perform_deliveries = false
    end
  end

  # Email #1 to prior year reservations
  def marketing_email_1
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return if @reservation.is_marketing_email_1_sent?
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling #{nice_long_date_short(Time.parse(EVENT_DATE_AND_PICKUP_TIME))}. Register today.")
    @reservation.logs.create(message: 'Marketing email 1 sent.')
    @reservation.update(is_marketing_email_1_sent: true)
  end

  # Email #2 to prior year reservations
  def marketing_email_2
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return if @reservation.is_marketing_email_2_sent?
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Last call! Tree recycling #{nice_long_date_short(Time.parse(EVENT_DATE_AND_PICKUP_TIME))}")
    @reservation.logs.create(message: 'Marketing email 2 sent.')
    @reservation.update(is_marketing_email_2_sent: true)
  end
end
