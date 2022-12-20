FactoryBot.define do
  factory :user, aliases: [ :viewer ] do
    email { Faker::Name.first_name.downcase + '.' + Faker::Name.last_name.downcase + '@example.com' }
    password { Faker::Internet.password }
    role { 'viewer'}

    factory :editor do 
      role { :editor }
    end

    factory :administrator do 
      role { :administrator }
    end

  end
end
