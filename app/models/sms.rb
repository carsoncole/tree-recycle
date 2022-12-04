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

  def send_with_object(obj, message)
    begin
      return unless obj.phone.present?
      return if obj.respond_to?(:no_sms) && obj.no_sms?

      response = client.messages.create(
        from: @from_number,
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


  def from_number
    @from_number = if Rails.env.test?
      Rails.application.credentials.twilio.test.number
    else
      Rails.application.credentials.twilio.production.number
    end
  end


  def send(phone, message)
    response = client.messages.create(
      from: from_number,
      to: phone,
      body: message
    )
  end

end
