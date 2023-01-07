class Message < ApplicationRecord
  belongs_to :reservation, optional: true

  after_create_commit -> { broadcast_replace_to "messages-count", partial: "admin/messages/count" , target: 'messages-count'}, if: -> (obj) { obj.incoming? }

  validates :number, :body, :direction, presence: true

  enum :direction, { outgoing: 1, incoming: 2 }

  attribute :direction, default: :outgoing

  after_validation :normalize_number!
  after_create :send_sms!, if: -> (obj){ obj.outgoing? }

  def send_sms!
    SendSmsJob.perform_later(self.number, self.body)
  end

  # removes spaces, hypens
  def normalize_number!
    self.number = E164.normalize(number) if number.present?
  end

  def self.unviewed?(number)
    where(number: number, viewed: false).any?
  end
end
