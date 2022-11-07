class StripeCharge

  def initialize(event)
    @stripe_charge = event.data.object
    puts @stripe_charge.inspect
  end

  def process
    charge if @stripe_charge.object == 'checkout.session'
  end

  private

  def charge
    reservation = Reservation.where(id: @stripe_charge.client_reference_id).first
    amount = @stripe_charge.amount_total == 0 ? 0 : @stripe_charge.amount_total / 100.0
    Donation.create(
      reservation_id: reservation&.id,
      checkout_session_id: @stripe_charge.id,
      amount: amount,
      status: @stripe_charge.status,
      payment_status: @stripe_charge.payment_status,
      email: @stripe_charge.customer_details&.email
      )
  end
end
