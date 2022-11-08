require 'usps'

#TODO need archiving process
class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit form_1 address_verification submit_reservation update destroy ]

  def show
  end

  def new
    redirect_to root_url, alert: "Reservations are CLOSED. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
    @reservation = Reservation.new
    if params[:reservation_id]
      old_reservation = Reservation.find(params[:reservation_id])
      @reservation.street = old_reservation.street
      @reservation.email = old_reservation.email
      @reservation.name = old_reservation.name
    end
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
      @reservation.pending_pickup! if !@reservation.pending_pickup?
      message = if @reservation.pending_pickup?
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
      @reservation.cancelled!
      redirect_to reservation_url(@reservation), notice: "Reservation was successfully cancelled."
    else
      redirect_to reservation_url(@reservation), alert: "Reservations are no longer changeable. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
    end
  end

  def upload
    Reservation.import(params[:reservation][:file])
    redirect_to reservations_path #=> or where you want
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :latitude, :longitude, :notes, :file)
    end
end
