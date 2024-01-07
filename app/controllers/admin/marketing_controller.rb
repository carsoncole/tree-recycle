class Admin::MarketingController < Admin::AdminController
  def index
  end

  def send_marketing_email_1
    if current_user.administrator?
      system "rake marketing:send_email_1_to_archived_customers"
      redirect_to admin_marketing_index_path, notice: "Marketing email 1 has been queued, with a batch size of #{ helpers.setting.email_batch_quantity } emails, for delivery."
    else
      redirect_to admin_marketing_index_path, notice: 'Unauthorized. Administrator access is required.'
    end
  end

  def send_marketing_email_2
    if current_user.administrator?
      system "rake marketing:send_email_2_to_archived_customers"
      redirect_to admin_marketing_index_path, notice: "Marketing email 2 has been queued, with a batch size of #{ helpers.setting.email_batch_quantity } emails, for delivery."
    else
      redirect_to admin_marketing_index_path, notice: 'Unauthorized. Administrator access is required.'
    end
  end

  def reset_sent_campaigns
    if current_user.administrator?
      Reservation.archived.update_all(is_marketing_email_1_sent: false, is_marketing_email_2_sent: false)
      redirect_to admin_marketing_index_path, notice: "All Archived reservations are reset and can be sent new campaign emails."
    else
      redirect_to admin_marketing_index_path, notice: 'Unauthorized. Administrator access is required.'
    end
  end
end
