class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pagy::Backend
end
