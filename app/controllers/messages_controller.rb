class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def client
    if Rails.env.test?
      sid, auth_token = Rails.application.credentials.twilio.test.account_sid, Rails.application.credentials.twilio.test.auth_token
    else
      sid, auth_token = Rails.application.credentials.twilio.production.account_sid, Rails.application.credentials.twilio.production.auth_token
    end

    @client = Twilio::REST::Client.new sid, auth_token
  end

  def reply
    message_body = params["Body"]
    from_number = params["From"]
    to_number = params["To"]

    m = Message.create(
      number: from_number,
      body: message_body,
      direction: 'incoming'
      )
  end

  private

end
