class Setting < ApplicationRecord

  def self.primary
    first ||= nil
  end
end
