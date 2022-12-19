class DriverRoute < ApplicationRecord
  belongs_to :driver
  belongs_to :route

  validates :driver, uniqueness: {scope: :route}
end

