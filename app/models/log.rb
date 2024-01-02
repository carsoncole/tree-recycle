class Log < ApplicationRecord
  belongs_to :reservation

  enum category: { general: 1, missing_tree_status: 5, missing_tree_email: 7, missing_tree_sms: 8 }, _default: "general"

  after_create_commit -> { broadcast_prepend_to "logs", partial: "admin/logs/log" }

  def self.email_count_last_24_hours
    where(message: ['Donation receipt email sent.', 'Confirmed reservation email sent.', 'Marketing email 1 sent.', 'Marketing email 2 sent.', 'Pick up reminder email sent.' ]).where("created_at > ?", Time.now - 24.hours).count
  end
end

