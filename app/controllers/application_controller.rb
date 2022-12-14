class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pagy::Backend

  def driver_signed_in?
    cookies.permanent[:driver_key] = params[:key] if params[:key]

    if Setting&.first&.driver_secret_key.present?
      if (cookies[:driver_key] && cookies[:driver_key] == Setting&.first&.driver_secret_key) || signed_in?
        true
      else
        false
      end
    else
      true
    end
  end
end
