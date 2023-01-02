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
    mail(to: @reservation.email, subject: "Tree recycling #{nice_long_date_short(setting.pickup_date_and_time)}. Register today.")
    @reservation.logs.create(message: 'Marketing email 1 sent.')
    @reservation.update(is_marketing_email_1_sent: true)
  end

  # Email #2 to prior year reservations
  def marketing_email_2
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return if @reservation.is_marketing_email_2_sent?
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Last call! Tree recycling #{nice_long_date_short(setting.pickup_date_and_time)}")
    @reservation.logs.create(message: 'Marketing email 2 sent.')
    @reservation.update(is_marketing_email_2_sent: true)
  end
end
