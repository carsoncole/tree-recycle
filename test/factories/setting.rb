FactoryBot.define do
  factory :setting do
    # defaults are set in the model class

    factory :setting_with_driver_auth do
      driver_secret_key { Faker::Internet.password }
    end

  end
end
