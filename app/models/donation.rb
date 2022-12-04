class Donation < ApplicationRecord
  belongs_to :reservation, optional: true

  after_create :send_receipt_email!, if: -> (obj){ obj.amount != 0 && obj.email.present? &&  obj.payment_status == 'paid' }
  after_create :send_donation_sms!


  def send_receipt_email!
    DonationsMailer.with(donation: self).receipt_email.deliver_later
  end

  #OPTIMIZE moved admin_mobile_phone to settings and allow for multiple numbers
  def send_donation_sms!
    Message.create(
      body: "Tree Recycle donation: $#{ self.amount.to_s } by #{ self.email }",
      to: Rails.application.credentials.admin_mobile_phone
      )
  end
end
