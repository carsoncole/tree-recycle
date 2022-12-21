class SitemapController < ApplicationController
  layout false

  def index
    respond_to do |format|
      format.xml
    end
  end
end
