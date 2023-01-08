class Donation < ApplicationRecord
  belongs_to :reservation, optional: true
  validates :form, presence: true

  after_update :send_receipt_email!, if: -> (obj){ obj.amount.positive? && obj.email.present? && !obj.saved_change_to_is_receipt_email_sent? }

  enum :form, { online: 1, cash_or_check: 2 }, default: 1

  def send_receipt_email!
    return if self.is_receipt_email_sent?
    DonationsMailer.with(donation: self).receipt_email.deliver_later
  end
end
