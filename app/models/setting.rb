#TODO add is_reservations_enabled
class Setting < ApplicationRecord

  def self.primary
    first ||= nil
  end
end
