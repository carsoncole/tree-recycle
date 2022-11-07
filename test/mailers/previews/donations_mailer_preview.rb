# Preview all emails at http://localhost:3000/rails/mailers/
class DonationsMailerPreview < ActionMailer::Preview

  def receipt_email
    Donation.first.update(is_receipt_email_sent: false)
    donation = Donation.first
    DonationsMailer.with(donation: donation).receipt_email
  end
end
