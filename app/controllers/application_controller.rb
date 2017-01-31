class ApplicationController < ActionController::Base
  require 'sessions_helper'
  include SessionsHelper

  helper_method :current_user

  def error
    raise "inentionally raising error"
  end
end
