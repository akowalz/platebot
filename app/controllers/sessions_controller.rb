class SessionsController < ApplicationController
  def create
    @auth = request.env["omniauth.auth"]
    if @cooper = Cooper.find_by_uid(@auth[:uid])
      sign_in(@cooper)
      flash[:success] = "Signed in successfully"

      redirect_to root_path
    else
      # they need to provide more info to sign up
      render template: 'coopers/new'
    end
  end

  def destroy
    sign_out
    flash[:success] = "Signed out successfully"
    redirect_to root_path
  end
end
