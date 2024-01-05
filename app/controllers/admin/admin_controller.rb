class Admin::AdminController < ApplicationController
  before_action :require_login

  def index
    @missing_reservations = Reservation.missing
    @count_picked_up = Reservation.picked_up.count
    @count_pending_pickups = Reservation.pending_pickup.count
    @count_missing = Reservation.missing.count
  end
end
