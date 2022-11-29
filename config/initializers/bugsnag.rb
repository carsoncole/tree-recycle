if Rails.env.production?
  Bugsnag.configure do |config|
    config.api_key = Rails.application.credentials.bugsnag.api_key 
    config.app_version = '1.5.0'
  end
end
