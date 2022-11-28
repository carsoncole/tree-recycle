class Sms

  attr_accessor :client

  def client
    if Rails.env.test? 
      sid, auth_token = Rails.application.credentials.twilio.test.account_sid, Rails.application.credentials.twilio.test.auth_token
    else
      sid, auth_token = Rails.application.credentials.twilio.production.account_sid, Rails.application.credentials.twilio.production.auth_token
    end

    @client = Twilio::REST::Client.new sid, auth_token
  end

  def send(obj, message, from_number=nil)
    begin
      return unless obj.phone.present?
      return if obj.respond_to(:no_sms).no_sms?

      from_number = '+15005550006' if Rails.env.test?

      response = client.messages.create(
        from: from_number || Setting.first.sms_from_phone,
        to: obj.phone,
        body: message
      )
      obj.logs.create(message: "SMS message sent: '#{ message }'") if obj.respond_to?(:logs)

      return response

      rescue => exception
        if Rails.env.production?
          Bugsnag.notify(exception)
        else 
          exception
        end
      end

  end

end