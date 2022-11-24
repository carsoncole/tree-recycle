require "test_helper"

class DonationsMailerTest < ActionMailer::TestCase
  test "confirmed donation receipt email" do
    donation = create(:donation)
    email = DonationsMailer.with(donation: donation).receipt_email

    assert_emails 1 do
      email.deliver_now
    end

    # assert_equal ["me@example.com"], email.from
    assert_equal [donation.email], email.to
    assert_equal "Thank you for your donation", email.subject
    assert email.html_part.body.to_s.include? 'Thank you for your donation! Your donation directly supports the BSA Scout Troop 1564 and Troop 1804.'
  end
end
