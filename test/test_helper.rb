require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# configure omniauth to stub requests
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
  provider: "google_oauth2",
  uid: "123abc",
  info: {
    first_name: "Foo",
    last_name: "Bar"
  }
})

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include SessionsHelper
  setup :setup_db_clean
  teardown :clean_db

  def setup_db_clean
    DatabaseCleaner.start
  end

  def clean_db
    DatabaseCleaner.clean
  end
end
