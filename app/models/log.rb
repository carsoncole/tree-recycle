class Log < ApplicationRecord
  belongs_to :reservation

  after_create_commit -> { broadcast_prepend_to "logs", partial: "admin/logs/log" }

  def self.email_count_last_24_hours
    where(message: ['Donation receipt email sent.', 'Confirmed reservation email sent.', 'Marketing email 2 sent.', 'Pick up reminder email sent.' ]).where("created_at > ?", Time.now - 24.hours).count
  end
end

