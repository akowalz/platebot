require 'twilio-ruby'

class CoopersController < ApplicationController

  def new
    @cooper = Cooper.new
  end

  def create
    cooper = Cooper.new(cooper_params)
    if cooper.valid?
      cooper.save
      flash[:success] = "Success! PlateBot now knows your number. Text PlateBot 'status' to test it out"
      redirect_to root_path
    else
      flash[:error] = cooper.errors.full_messages
      redirect_to signup_path
    end
  end

  private
    def cooper_params
      params.require(:cooper).permit(
        :fname,
        :lname,
        :house,
        :number
      )
    end
end

