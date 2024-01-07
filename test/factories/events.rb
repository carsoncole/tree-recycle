FactoryBot.define do
  factory :event do
    reservation
    date { Time.now }
  end
end
