module Interceptors

  class EnvironmentEmailInterceptor
    def self.delivering_email(message)
      message.subject.prepend('[DEVELOPMENT] ') if Rails.env.development?
    end
  end

end