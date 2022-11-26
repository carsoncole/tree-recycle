class Sms

  attr_accessor :client

  def client
    @client = Twilio::REST::Client.new Rails.application.credentials.twilio.account_sid, Rails.application.credentials.twilio.auth_token
  end

  def send(obj, message)
    begin
      return unless obj.phone.present?

      client.messages.create(
        from: Setting.first.sms_from_phone,
        to: obj.phone,
        body: message
      )
      obj.logs.create(message: "SMS message sent: '#{ message }'") if obj.respond_to?(:logs)

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