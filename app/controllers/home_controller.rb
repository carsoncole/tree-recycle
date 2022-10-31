class HomeController < ApplicationController
  def index
  end

  def about
    @setting = Setting.first
  end

  def questions
    @setting = Setting.first
  end

end
