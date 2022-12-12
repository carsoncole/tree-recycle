#OPTIZE rescuing mailer errors may improve app resilience
class ApplicationMailer < ActionMailer::Base
  default from: "Bainbridge Tree Recycle <bainbridgeislandscouts@gmail.com>"
  layout "mailer"
  helper ApplicationHelper
end
