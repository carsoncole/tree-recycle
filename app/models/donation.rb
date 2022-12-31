class Donation < ApplicationRecord
  belongs_to :reservation, optional: true
  validates :form, presence: true

  after_create :send_receipt_email!, if: -> (obj){ obj.amount != 0 && obj.email.present? &&  obj.payment_status == 'paid' || 'succeeded' }
  after_save :send_donation_sms!, if: -> (obj){ obj.amount != 0 && !obj.saved_change_to_amount? }

  enum :form, { online: 1, cash_or_check: 2 }, default: 2

  def send_receipt_email!
    return if amount.nil? || amount == 0
    return unless email.present?
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
