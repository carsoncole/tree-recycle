Bugsnag.configure do |config|
  config.api_key = Rails.application.credentials.bugsnag.api_key if Rails.env.production?
end
