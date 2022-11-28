FactoryBot.define do
  factory :user, aliases: [ :viewer ] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    factory :editor do 
      role { :editor }
    end

    factory :administrator do 
      role { :administrator }
    end

  end
end
