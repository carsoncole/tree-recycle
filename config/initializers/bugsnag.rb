Bugsnag.configure do |config|
  if Rails.env.production?
    config.api_key = Rails.application.credentials.bugsnag.api_key 
    config.app_version = '1.3.0'
  end
end
