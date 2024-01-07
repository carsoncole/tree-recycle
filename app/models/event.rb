class Event < ApplicationRecord
  belongs_to :reservation

  validates :date, presence: true
  validates :reservation, uniqueness: { scope: :date }
end
