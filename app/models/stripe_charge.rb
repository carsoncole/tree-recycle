class StripeCharge

  def initialize(event)
    @stripe_event = event.data.object
    puts @stripe_event.inspect
  end

  def process
    checkout_session if @stripe_event.object == 'checkout.session'
    charge if @stripe_event.object == 'charge'
    payment_intent if @stripe_event.object == 'payment_intent'
  end

  private

  def charge
    amount = @stripe_event.amount == 0 ? 0 : @stripe_event.amount / 100.0
    amount_refunded = @stripe_event.amount_refunded == 0 ? 0 : @stripe_event.amount_refunded / 100.0
    stripe_payment_intent_id = @stripe_event.payment_intent
    donation = Donation.find_by_stripe_payment_intent_id(stripe_payment_intent_id)
    refunded = @stripe_event.refunded
    if donation && refunded
      donation.update(amount: amount - amount_refunded, status: 'refunded', receipt_url: @stripe_event.receipt_url )
    else
      # Donation.create(
      #   reservation_id: reservation&.id,
      #   checkout_session_id: @stripe_event.id,
      #   amount: amount,
      #   status: @stripe_event.status,
      #   payment_status: @stripe_event.payment_status,
      #   email: @stripe_event.customer_details&.email,
      #   )
    end
  end

  def checkout_session
    reservation = Reservation.where(id: @stripe_event.client_reference_id).first
    amount = @stripe_event.amount_total == 0 ? 0 : @stripe_event.amount_total / 100.0
    donation = Donation.find_or_create_by(stripe_payment_intent_id: @stripe_event.payment_intent)
    donation.update(
      checkout_session_id: @stripe_event.id,
      checkout_session_status: @stripe_event.status,
      checkout_session_customer_email: @stripe_event.customer_email,
      reservation_id: reservation&.id,
      amount: amount,
      status: @stripe_event.status,
      payment_status: @stripe_event.payment_status,
      email: @stripe_event.customer_details&.email,
      customer_name: @stripe_event.customer_details&.name,
      stripe_payment_intent_id: @stripe_event.payment_intent
      )    
  end

  def payment_intent
    amount = @stripe_event.amount == 0 ? 0 : @stripe_event.amount / 100.0
    donation = Donation.find_or_create_by(stripe_payment_intent_id: @stripe_event.id)
    donation.update(
      payment_intent_id: @stripe_event.id,
      email: @stripe_event.billing_details.email,
      customer_name: @stripe_event.billing_details.name,
      description: @stripe_event.billing_details.description,
      payment_status: @stripe_event.paid == true ? 'paid' : '',
      last4: @stripe_event.payment_method_details.last4,
      exp_month: @stripe_event.payment_method_details.exp_month,
      exp_year: @stripe_event.payment_method_details.exp_year,
      receipt_url: @stripe_event.payment_method_details.receipt_url,
      amount: amount
      )    
  end
end
