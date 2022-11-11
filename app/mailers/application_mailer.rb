class ApplicationMailer < ActionMailer::Base
  default from: "Bainbrdge Tree Recycle <bainbridge.tree.recycle@gmail.com>"
  layout "mailer"
  helper ApplicationHelper
end
