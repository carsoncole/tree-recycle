class DonationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_reservation, only: %i[ create new cash_or_check ]

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
      metadata: {reservation_id: params[:reservation_id]},
      customer_email: @reservation.email,
      success_url: reservation_success_url(@reservation),
      cancel_url: new_reservation_donation_url(@reservation)
    })
    redirect_to @session.url, allow_other_host: true
  end

  def donation_without_reservation
    @session = Stripe::Checkout::Session.create({
      line_items: [{
          price: 'price_1Lxwp5AY1LGWbDshKyepVUDL',
          quantity: 1
      }],
      mode: 'payment',
      success_url: success_url,
      cancel_url: root_url
    })
    redirect_to @session.url, allow_other_host: true
  end



  def cash_or_check
    @reservation.update(is_cash_or_check: true)
    redirect_to reservation_url(@reservation), notice: "You are all set. Your reservation is confirmed."
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
