require 'usps'

class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit form_1 address_verification submit_reservation update destroy ]

  def show
  end

  def new
    redirect_to root_url, alert: "Reservations are CLOSED. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
    @reservation = Reservation.new
  end

  def edit
    redirect_to reservation_url(@reservation), alert: "Reservations are no longer changeable. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
  end

  #FIXME review purpose of !address.valid?
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
        @reservation.update(is_confirmed: true)
        redirect_to new_reservation_donation_url(@reservation), notice: 'Your reservation is confirmed.'
      else
        redirect_to reservation_address_verification_url(@reservation)
      end

    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    redirect_to root_url, alert: "Reservations are no longer changeable. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
    if @reservation.update(reservation_params)
      @reservation.update(is_confirmed: true) if !@reservation.is_confirmed
      message = if @reservation.is_confirmed?
        "Reservation was successfully updated and is confirmed for pick up."
      else
        "Please review your reservation"
      end
      redirect_to new_reservation_donation_url(@reservation), notice: message
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def submit_reservation
    redirect_to new_reservation_donation_url(@reservation)
  end

  def destroy
    if Reservation.open?
      @reservation.update(is_cancelled: true)
      redirect_to reservation_url(@reservation), notice: "Reservation was successfully cancelled."
    else
      redirect_to reservation_url(@reservation), alert: "Reservations are no longer changeable. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
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
