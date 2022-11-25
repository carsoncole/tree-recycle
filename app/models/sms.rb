class Sms

  attr_accessor :client

  def client
    @client = Twilio::REST::Client.new Rails.application.credentials.twilio.account_sid, Rails.application.credentials.twilio.auth_token
  end

  def send(phone, message)
    begin

      client.messages.create(
        from: Setting.first.sms_from_phone,
        to: phone,
        body: message
      )

      rescue => exception
        if Rails.env.production?
          Bugsnag.notify(exception)
        else 
          puts "*" * 40
          puts exception 
        end
      end

  end

end