class HomeController < ApplicationController
  def index
  end

  def about
    @site_title = 'Tree Pickup'
  end

  def questions
    @site_title = 'Have a question?'
  end

  def software
    @site_title = 'Learn more about the software'
  end
end
