class MarketingMailer < ApplicationMailer
  include ApplicationHelper
  before_action :set_reservation
  before_action :set_headers

  def set_reservation
    @reservation = params[:reservation]
  end

  def set_headers
    unsubscribe_url = reservation_unsubscribe_url(@reservation)
    headers['List-Unsubscribe'] = "<#{unsubscribe_url}>"
  end

  # email to prior year reservations
  def hello_email
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling on #{nice_long_date(setting.pickup_date_and_time)}")
    @reservation.logs.create(message: 'Hello email sent.')
  end

  # email last reminder to prior year reservations
  def last_call_email
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling last reminder for #{nice_long_date(setting.pickup_date_and_time)}")
    @reservation.logs.create(message: 'Last call email sent.')
  end
end