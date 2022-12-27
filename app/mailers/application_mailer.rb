#OPTIZE rescuing mailer errors may improve app resilience
class ApplicationMailer < ActionMailer::Base
  default from: MAIL_FROM
  layout "mailer"
  helper ApplicationHelper
end
