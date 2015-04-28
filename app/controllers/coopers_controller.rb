require 'twilio-ruby'

class CoopersController < ApplicationController

  def new
    @cooper = Cooper.new
  end

  def create
    cooper = Cooper.new(cooper_params)
    if cooper.valid?
      cooper.save
      flash[:success] = "Your account has been created! Text PlateBot 'status' to confirm!"
      redirect_to root_path
    else
      flash[:error] = cooper.errors.full_messages
      redirect_to signup_path
    end
  end

  def show
    # @plates = Cooper.find(params[:id]).late_plates.upcoming
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

