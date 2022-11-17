class Driver::DriverController < ApplicationController
  before_action :is_driver_signed_in?
  before_action :set_title

  def set_title
    @site_title = 'Tree Recycle Driver'
  end

  def is_driver_signed_in?
    unless driver_signed_in?
      redirect_to sign_in_path
    end
    true
  end
end
