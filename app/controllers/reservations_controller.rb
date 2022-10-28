require 'usps'

class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit form_1 form_2 address_verification submit_reservation update destroy ]
  before_action :require_login, only: %i[ index destroy ]

  def show
  end

  def new
    @reservation = Reservation.new
  end

  def edit
  end

  def form_1
  end

  def form_2
  end

  def address_verification
    USPS.config.username = Rails.application.credentials.usps.username
    address = USPS::Address.new(address1: @reservation.street, city: @reservation.city, state: @reservation.state)
    req = USPS::Request::AddressStandardization.new(address)
    begin
      response = req.send!
      if !address.valid?
        render :form_2
      end
      @verified_street = response.get(address).address1
    rescue USPS::AddressNotFoundError
      @address_not_found = true
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      if @reservation.geocoded?
        redirect_to reservation_form_2_url(@reservation)
      else
        redirect_to reservation_address_verification_url(@reservation)
      end

    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to reservation_url(@reservation), notice: @reservation.is_completed? ? "Reservation was successfully updated." : "Please review your reservation"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def submit_reservation
    @reservation.update(is_completed: true)
    redirect_to new_reservation_donation_url(@reservation)
  end

  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :latitude, :longitude, :notes)
    end
end
