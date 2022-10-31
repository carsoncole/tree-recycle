class AboutController < ApplicationController
  def index
    @setting = Setting.first
  end
end
