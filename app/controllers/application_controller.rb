class ApplicationController < ActionController::Base
  include SessionsHelper

  helper_method :current_user

  def error
    raise "intentionally raising error"
  end

  private

  def verify_current_user
    unless current_user && (current_user == @cooper || current_user.admin?)
      flash[:warning] = "Please sign in first!"
      redirect_to root_path
    end
  end

  def verify_user_is_admin
    unless current_user && current_user.admin?
      flash[:warning] = "Only admins can view this page."
      redirect_to root_path
    end
  end
end
