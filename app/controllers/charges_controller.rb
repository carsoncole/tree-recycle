class ChargesController < ApplicationController

  def new
    @reservation = Reservation.find(params[:reservation_id])
  end
end
