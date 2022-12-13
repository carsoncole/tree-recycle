class Donation < ApplicationRecord
  belongs_to :reservation, optional: true

  after_create :send_receipt_email!, if: -> (obj){ obj.amount != 0 && obj.email.present? &&  obj.payment_status == 'paid' }
  after_create :send_donation_sms!


  def send_receipt_email!
    DonationsMailer.with(donation: self).receipt_email.deliver_later
  end

  # sends a notification on every donation
  def send_donation_sms!
    notification_number = Setting&.first&.donation_notification_sms_number
    Message.create(
      body: "Tree Recycle donation: $#{ self.amount.to_s } by #{ self.email }",
      number: notification_number
      ) if notification_number.present?
  end
end
