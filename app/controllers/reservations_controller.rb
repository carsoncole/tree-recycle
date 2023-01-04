
class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit form_1 address_verification submit_confirmed_reservation update destroy confirmed unsubscribe resubscribe]

  def show
  end

  def new
    @site_title = 'Register for a tree pickup'
    unless signed_in?
      redirect_to root_url, alert: "Reservations are CLOSED. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
    end
    @reservation = Reservation.new
    if params[:reservation_id]
      begin
        old_reservation = Reservation.find(params[:reservation_id])
        @reservation.street = old_reservation.street
        @reservation.email = old_reservation.email
        @reservation.name = old_reservation.name unless old_reservation.name.downcase == 'no name provided'
        @reservation.notes = old_reservation.notes
        @reservation.years_recycling = old_reservation.years_recycling + 1
      rescue => e
        Rollbar.log('error', e)
      end
    end
  end

  def edit
  end

  def address_verification
    @site_title = 'Address verification'
    USPS.config.username = Rails.application.credentials.usps.username
    address = USPS::Address.new(address1: @reservation.street, city: @reservation.city, state: @reservation.state)
    req = USPS::Request::AddressStandardization.new(address)
    begin
      response = req.send!
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

  def create
    @reservation = Reservation.new(reservation_params)

    if !Reservation.open? && !signed_in?
      redirect_to root_url, alert: "Reservations are CLOSED."
    elsif @reservation.save
      if @reservation.geocoded?
        @reservation.pending_pickup!
        redirect_to new_reservation_donation_url(@reservation)
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

  def confirmed
    @site_title = 'Tree pickup confirmed'
    render :show
  end

  def destroy
    if Reservation.open?
      @reservation.cancelled!
      redirect_to reservation_url(@reservation), notice: "Reservation was successfully cancelled."
    else
      redirect_to reservation_url(@reservation), alert: "Reservations are no longer changeable. #{view_context.link_to('Contact us', '/questions')} if you have questions." unless Reservation.open?
    end
  end

  def unsubscribe
    @reservation.update(no_emails: true)
    @reservation.logs.create(message: 'Unsubscribed from emails.')
  end

  def resubscribe
    @reservation.update(no_emails: false)
    @reservation.logs.create(message: 'Resubscribed to emails.')
  end

  private
    def set_reservation
      if params[:id]
        @reservation = Reservation.find(params[:id])
      elsif params[:reservation_id]
        @reservation = Reservation.find(params[:reservation_id])
      end
    end

    def reservation_params
      params.require(:reservation).permit(:name, :email, :phone, :street, :city, :state, :zip, :country, :latitude, :longitude, :notes, :heard_about_source, :years_recycling)
    end
end
