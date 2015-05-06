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

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include SessionsHelper

  # Add more helper methods to be used by all tests here...
end
