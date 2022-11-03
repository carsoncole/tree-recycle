module ApplicationHelper
  include Pagy::Frontend

  def setting
    Setting.first
  end
end
