class Admin::MarketingController < Admin::AdminController
  def index
    @sources = Reservation.not_archived.heard_about_sources
    @donation_counts = Reservation.not_archived.group(:donation).count
    @reservations_count = Reservation.not_archived.count
    @donation_count = Donation.joins(:reservation).where.not("reservations.status IN(0, 4, 99)").count
    @total_donations = Donation.joins(:reservation).where.not("reservations.status IN (0,4,99)").sum(:amount)
    donations_ordered = Donation.joins(:reservation).order(:amount).where.not("reservations.status IN (0,4,99)")
    @median = if @donation_count == 0
        0
      elsif @donation_count.odd?
        donations_ordered[(@donation_count/2.0).ceil].amount
      else
        (donations_ordered[ (@donation_count/2.0).ceil ].amount + donations_ordered[ (@donation_count/2.0).floor-1 ].amount)/ 2.0
      end
    @average_donation = @total_donations / @donation_count
  end

  def send_marketing_email_1
    if current_user.administrator?
      system "rake marketing:send_email_1_to_archived_customers"
      redirect_to admin_settings_path, notice: "Marketing email 1 has been queued, with a batch size of #{ helpers.setting.email_batch_quantity } emails, for delivery."
    else
      redirect_to admin_settings_path, notice: 'Unauthorized. Administrator access is required.'
    end
  end

  def send_marketing_email_2
    if current_user.administrator?
      system "rake marketing:send_email_2_to_archived_customers"
      redirect_to admin_settings_path, notice: "Marketing email 2 has been queued, with a batch size of #{ helpers.setting.email_batch_quantity } emails, for delivery."
    else
      redirect_to admin_settings_path, notice: 'Unauthorized. Administrator access is required.'
    end
  end

  def reset_sent_campaigns
    if current_user.administrator?
      Reservation.archived.update_all(is_marketing_email_1_sent: false, is_marketing_email_2_sent: false)
      redirect_to admin_settings_path, notice: "All Archived reservations are reset and can be sent new campaign emails."
    else
      redirect_to admin_settings_path, notice: 'Unauthorized. Administrator access is required.'
    end
  end
end
