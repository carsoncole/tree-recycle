class Driver < ApplicationRecord
  belongs_to :zone, optional: true
end
