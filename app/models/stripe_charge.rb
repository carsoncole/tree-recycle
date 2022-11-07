class StripeCharge

  def initialize(event)
    @stripe_charge = event.data.object
  end

  def process
    charge.update(charged_at: Time.zone.now) if charge
  end

  private

  def charge
    @charge ||= Donation.where(amount: @stripe_charge.net_amount / 100.0).first! rescue nil
  end
end
