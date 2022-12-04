class Message < ApplicationRecord
  belongs_to :reservation, optional: true

  validates :number, :body, :direction, presence: true

  enum :direction, { outgoing: 1, incoming: 2 }

  attribute :direction, default: :outgoing

  after_validation :clean_number!
  after_create :send_sms!, if: -> (obj){ obj.outgoing? }

  def send_sms!
    SendSmsJob.perform_later(self.number, self.body)
    # Sms.new.send(self.number, self.body)
  end

  # removes spaces, hypens
  def clean_number!
    self.number = number.gsub(/(?!^\+)\D*/, '')
  end

  def self.unviewed?(number)
    where(number: number, viewed: false).any?
  end
end
