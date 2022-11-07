class Donation < ApplicationRecord
  belongs_to :reservation, optional: true

  after_create :send_receipt_email!, if: -> (obj){ obj.amount != 0 && obj.email.present? &&  obj.payment_status == 'paid' }

  def send_receipt_email!
    DonationsMailer.with(donation: self).receipt_email.deliver_later
  end

end
