class SendSmsJob < ApplicationJob
  queue_as :urgent

  def perform(*args)
    Sms.new.send( args[0], args[1] )
  end
end
