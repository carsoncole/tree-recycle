class MarketingMailer < ApplicationMailer
  before_action :set_reservation
  after_action :stop_delivery_if_disabled

  def set_reservation
    @reservation = params[:reservation]
  end

  # Email #1 to prior year reservations
  def marketing_email_1
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling on #{nice_long_date(setting.pickup_date_and_time)}")
    @reservation.logs.create(message: 'Marketing email 1 sent to archived')
  end

  # Email #2 to prior year reservations
  def marketing_email_2
    return if @reservation.no_emails? || !setting.is_emailing_enabled
    return unless @reservation.archived? # don't send to current reservations
    mail(to: @reservation.email, subject: "Tree recycling last reminder for #{nice_long_date(setting.pickup_date_and_time)}")
    @reservation.logs.create(message: 'Marketing email 2 sent to archived')
  end

end
