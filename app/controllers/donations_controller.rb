class DonationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_reservation, only: %i[ create new cash_or_check success]

  def new
  end

  def create
    @session = Stripe::Checkout::Session.create({
      line_items: [{
          price: 'price_1Lxwp5AY1LGWbDshKyepVUDL',
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

  #FIXME donation_without_reservation needs reviewing/fixing
  def donation_without_reservation
    @session = Stripe::Checkout::Session.create({
      line_items: [{
          price: 'price_1Lxwp5AY1LGWbDshKyepVUDL',
          quantity: 1
      }],
      mode: 'payment',
      client_reference_id: '1212121',
      customer_email: 'carson@cole.com',
      success_url: success_url,
      cancel_url: root_url
    })
    redirect_to @session.url, allow_other_host: true
  end

  def cash_or_check
    @reservation.update(is_cash_or_check: true)
    redirect_to reservation_url(@reservation), notice: "Your tree pick-up is confirmed. You can leave your donation with your tree."
  end

  def stripe_webhook
    event = Stripe::Event.retrieve(params[:id])
    StripeCharge.new(event).process
    render nothing: true, status: 201
  rescue Stripe::APIConnectionError, Stripe::StripeError
    render nothing: true, status: 400
  end

  def success
  end

  def cancel
  end

  private
    def donation_params
      params.require(:donation).permit(:amount)
    end
    def set_reservation
      @reservation = Reservation.find(params[:id] ||= params[:reservation_id])
    end
end
