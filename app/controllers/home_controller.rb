class HomeController < ApplicationController
  include ApplicationHelper

  def index
    flash[:warning] = setting.reservations_closed_message unless setting.is_reservations_open?
    @remind_me = RemindMe.new
  end

  def about
    @site_title = 'Tree pickup details'
  end

  def questions
    @site_title = 'Have a question?'
  end

  def software
    @site_title = 'Learn more about the software'
  end
end
