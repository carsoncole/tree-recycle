class Log < ApplicationRecord
  belongs_to :reservation

  default_scope { order(created_at: :asc) }
end
