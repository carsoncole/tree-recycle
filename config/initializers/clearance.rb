Clearance.configure do |config|
  config.routes = false
  config.allow_sign_up = true
  config.mailer_sender = "Bainbrdge Tree Recycle <troop_1564@treerecycle.net>"
  config.rotate_csrf_on_sign_in = true
  config.redirect_url = '/admin'
end
