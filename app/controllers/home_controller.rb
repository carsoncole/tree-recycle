class HomeController < ApplicationController
  def index
  end

  def questions
    @setting = Setting.first
  end

end
