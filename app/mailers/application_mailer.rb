#OPTIZE rescuing mailer errors may improve app resilience
class ApplicationMailer < ActionMailer::Base
  default from: "Bainbrdge Tree Recycle <troop_1564@treerecycle.net>"
  # default from: "Bainbrdge Tree Recycle <bainbridge.tree.recycle@gmail.com>"
  layout "mailer"
  helper ApplicationHelper
end
