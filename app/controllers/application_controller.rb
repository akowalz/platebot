class ApplicationController < ActionController::Base
  # csrf protection removed for Twilio
  #
  require 'sessions_helper'

  include SessionsHelper

  helper_method :current_user
end
