class SendSmsJob < ApplicationJob
  queue_as :urgent

  def perform(*args)
    Sms.new.send_without_log( args[0], args[1] )
  end
end
