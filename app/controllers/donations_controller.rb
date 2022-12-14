class DonationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_reservation, only: %i[ create new cash_or_check no_donation ]

  def new
  end

  def create
    @reservation.online_donation!
    @session = Stripe::Checkout::Session.create({
      line_items: [{
          price: Rails.env.production? ? STRIPE_PRODUCTION_PRICE_ITEM : STRIPE_DEVELOPMENT_PRICE_ITEM,
          quantity: 1
      }],
      mode: 'payment',
      client_reference_id: @reservation.id,
      metadata: {reservation_id: @reservation.id},
      customer_email: @reservation.email,
      success_url: reservation_success_url(@reservation),
      cancel_url: new_reservation_donation_url(@reservation)
    })
    redirect_to @session.url, allow_other_host: true
  end

  def donation_without_reservation
    @session = Stripe::Checkout::Session.create({
      line_items: [{
          price: Rails.env.production? ? STRIPE_PRODUCTION_PRICE_ITEM : STRIPE_DEVELOPMENT_PRICE_ITEM,
          quantity: 1
      }],
      mode: 'payment',
      success_url: success_url(driver: params[:driver] == 'true' ? true : false),
      cancel_url: params[:driver] && params[:driver] == 'true' ? driver_root_url : root_url
    })
    redirect_to @session.url, allow_other_host: true
  end

  def cash_or_check
    @reservation.cash_or_check_donation!
    @reservation.logs.create(message: 'Cash or check donation option selected.')
    redirect_to reservation_confirmed_url(@reservation), notice: "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  def no_donation
    @reservation.no_donation!
    @reservation.logs.create(message: 'No donation option selected.')
    redirect_to reservation_confirmed_url(@reservation)
  end

  def stripe_webhook
    event = Stripe::Event.retrieve(params[:id])
    StripeCharge.new(event).process
    render nothing: true, status: 201
  rescue Stripe::APIConnectionError, Stripe::StripeError
    render nothing: true, status: 400
  end

  def success
    if params[:reservation_id] || params[:id]
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
      @reservation.logs.create(message: 'Online donation successful.')
    end
    @driver = true if params[:driver] == true
    flash[:notice] = 'Thank you! Your donation is greatly appreciated and goes a long way towards supporting Scouting on Bainbridge Island.'
  end

  private
    def donation_params
      params.require(:donation).permit(:amount)
    end
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end
end
