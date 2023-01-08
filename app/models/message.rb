#OPTIMIZE View status is not specific to any user--should be
class Message < ApplicationRecord
  belongs_to :reservation, optional: true
  has_many :reservations, foreign_key: "phone"

  before_save :normalize_phone
  after_create_commit -> { broadcast_replace_to "messages-count", partial: "admin/messages/count" , target: 'messages-count'}, if: -> (obj) { obj.incoming? }

  validates :phone, :body, :direction, presence: true

  enum :direction, { outgoing: 1, incoming: 2 }

  attribute :direction, default: :outgoing

  after_create :send_sms!, if: -> (obj){ obj.outgoing? }

  def send_sms!
    SendSmsJob.perform_later(self.phone, self.body)
  end

  def self.unviewed?(phone)
    where(phone: phone, viewed: false).any?
  end

  def normalize_phone
    self.phone = Phonelib.parse(phone).full_e164.presence
  end

  def formatted_phone
    parsed_phone = Phonelib.parse(phone)
    return phone if parsed_phone.invalid?

    formatted =
      if parsed_phone.country_code == "1" # NANP
        parsed_phone.full_national # (415) 555-2671;123
      else
        parsed_phone.full_international # +44 20 7183 8750
      end
    formatted.gsub!(";", " x") # (415) 555-2671 x123
    formatted
  end
end
