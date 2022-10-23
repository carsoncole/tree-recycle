class Admin::ReservationsController < ApplicationController
  before_action :require_login
  before_action :set_reservation, except: %i[ new index map ]


  def index
    if params[:zone_id]
      @pagy, @reservations = pagy(Reservation.where(zone_id: params[:zone_id]).order(created_at: :asc))
    else
      @pagy, @reservations = pagy(Reservation.order(created_at: :asc))
    end
  end

  def edit
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to admin_reservation_url(@reservation), notice: "Reservation was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :latitude, :longitude, :zone_id)
    end
end
