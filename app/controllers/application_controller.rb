class ApplicationController < ActionController::Base
  require 'sessions_helper'
  include SessionsHelper

  helper_method :current_user

  def error
    raise "intentionally raising error"
  end

  private

  def verify_current_user
    unless current_user && current_user == @cooper
      flash[:warning] = "Please sign in first!"
      redirect_to root_path
    end
  end
end
