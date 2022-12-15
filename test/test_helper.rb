require 'simplecov'
SimpleCov.start 'rails' do 
  add_filter '/channels/'
  add_filter '/jobs/'
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include ApplicationHelper
  include FactoryBot::Syntax::Methods
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  def system_test_signin
    @user = create(:editor)
    visit '/admin'
    click_on 'Sign in'
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    within '#clearance' do
      click_on "Sign in"
    end
    sleep 0.25 # tests were occasionally failing without this
  end

  def setting_generate_driver_secret_key!
    setting.update(driver_secret_key: Faker::Internet.password)
  end

  def random_email
    Faker::Name.first_name.underscore + '@example.com'
  end

end
