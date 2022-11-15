#TODO maps need to be added to admin/driver pages
class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pagy::Backend

end
