class Donation < ApplicationRecord
  belongs_to :reservation, optional: true

  after_create :send_receipt_email!, if: -> (obj){ obj.amount != 0 && obj.email.present? &&  obj.payment_status == 'paid' }
  after_create :send_donation_sms!


  def send_receipt_email!
    DonationsMailer.with(donation: self).receipt_email.deliver_later
  end

  def send_donation_sms!
    SendSmsJob.perform_later(Rails.application.credentials.admin_mobile_phone, "Tree Recycle donation: $#{ self.amount.to_s } by #{ self.email }")
  end

end
