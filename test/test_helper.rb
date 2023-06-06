ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "authlogic/test_case"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def log_in_as(user)
    visit root_path
    fill_in "Login", with: user.login
    fill_in "Password", with: user.login
    click_on "Login"
    page.driver.browser.manage.add_cookie(:name => "user_credentials", :value => "#{user.persistence_token}::#{user.send(user.class.primary_key)}")
  end

  def as_user(user)
    log_in_as(user)
    yield
  end

  def login(user)
    post user_session_url, :params => { :user_session => { :login => user.login, :password => user.login, :remember_me => false } }
  end
end
