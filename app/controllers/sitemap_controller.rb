class SitemapController < ApplicationController
  layout false

  def index
    headers['Content-Type'] = 'application/xml'
    respond_to do |format|
      format.xml
    end
  end
end
