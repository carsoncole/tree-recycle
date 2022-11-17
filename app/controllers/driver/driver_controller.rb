class Driver::DriverController < ApplicationController
  before_action :is_driver_signed_in?

  def is_driver_signed_in?
    unless driver_signed_in?
      redirect_to sign_in_path
    end
    true
  end
end
