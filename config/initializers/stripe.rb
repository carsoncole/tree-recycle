Stripe.api_key = if Rails.env.production?
  Rails.application.credentials.stripe.production.secret_key
else
  Rails.application.credentials.stripe.development.secret_key
end
