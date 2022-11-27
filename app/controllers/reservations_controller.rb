require 'usps'

class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit form_1 address_verification submit_confirmed_reservation update destroy ]

  def show
  end

  def new
    unless signed_in?
      redirect_to root_url, alert: "Reservations are CLOSED. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
    end
    @reservation = Reservation.new
    if params[:reservation_id]
      old_reservation = Reservation.find(params[:reservation_id])
      @reservation.street = old_reservation.street
      @reservation.email = old_reservation.email
      @reservation.name = old_reservation.name
    end
  end

  def edit
  end

  #FIXME review purpose of !address.valid?
  def address_verification
    USPS.config.username = Rails.application.credentials.usps.username
    address = USPS::Address.new(address1: @reservation.street, city: @reservation.city, state: @reservation.state)
    req = USPS::Request::AddressStandardization.new(address)
    begin
      response = req.send!
      # if !address.valid?
      #   render :form_2
      # end
      @verified_street = response.get(address).address1
      render status: 200 # http :bad_request
    rescue USPS::MultipleAddressError
      @multiple_addresses_found = true
      render status: 409 # http :conflict
    rescue USPS::AddressNotFoundError
      @address_not_found = true
      render status: 422 # http :not_found
    rescue
      @address_not_found = true
      render status: 400 # http :bad_request
    end
  end

  #OPTIMIZE Add check for reservations.open? unless signed_in
  def create
    @reservation = Reservation.new(reservation_params)

    if !Reservation.open? && !signed_in?
      redirect_to root_url, alert: "Reservations are CLOSED."
    elsif @reservation.save
      if @reservation.geocoded?
        @reservation.pending_pickup!
        redirect_to new_reservation_donation_url(@reservation), notice: 'You are all set! Your pickup reservation is confirmed.'
      else
        redirect_to reservation_address_verification_url(@reservation)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if Reservation.open?

      if @reservation.update(reservation_params)
        @reservation.pending_pickup! if @reservation.unconfirmed?
        message = if @reservation.pending_pickup?
          "Reservation was successfully updated and is confirmed for pick up."
        else
          "Please review your reservation"
        end
        redirect_to new_reservation_donation_url(@reservation), notice: message
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to reservation_url, alert: "Reservations are no longer changeable. #{view_context.link_to('Contact us', '/questions')} if you have questions."
    end
  end

  def submit_confirmed_reservation
    @reservation.pending_pickup!
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

  private
    def set_reservation
      if params[:id]
        begin
          @reservation = Reservation.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          @reservation_missing = true
          flash[:alert] = "Ooops! That reservation does not seem to exist. Please contact us if you think this is an error, or re-register your tree pickup."
        end
      elsif params[:reservation_id]
        @reservation = Reservation.find(params[:reservation_id])
      end
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :latitude, :longitude, :notes, :heard_about_source)
    end
end
