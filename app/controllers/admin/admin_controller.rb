class Admin::AdminController < ApplicationController
  before_action :require_login

  def index
    @missing_reservations = Reservation.missing
  end
end
