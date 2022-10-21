class Admin::ReservationsController < ApplicationController
  before_action :require_login
  before_action :set_reservation, except: %i[ new index map ]


  def index
    @pagy, @reservations = pagy(Reservation.order(created_at: :asc))
  end

  def edit
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end
end
