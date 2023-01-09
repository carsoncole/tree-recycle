class RemindMe < ApplicationRecord
  validates :name, :email, presence: true
end
