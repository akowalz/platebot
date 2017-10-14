require 'twilio-ruby'

class CoopersController < ApplicationController
  before_action :lookup_cooper, only: [:edit, :update]
  before_action :verify_current_user, only: [:edit, :update]

  def create
    @cooper = Cooper.new(cooper_params)
    if @cooper.valid?
      @cooper.save

      sign_in(@cooper)

      TwilioClient.send_message("Your Platebot confirmation code is #{@cooper.sms_confirmation_code}", @cooper.number)

      redirect_to new_cooper_sms_confirmation_path(@cooper)
    else
      flash[:error] = @cooper.errors.full_messages

      redirect_to new_cooper_path
    end
  end

  def edit
  end

  def update
    if @cooper.update_attributes(cooper_params)
      flash[:success] = "Your info has been updated!"
      redirect_to root_path
    else
      flash.now[:error] = @cooper.errors.full_messages
      render 'edit'
    end
  end

  private

  def lookup_cooper
    @cooper = Cooper.find(params[:id])
  end

  def cooper_params
    params.require(:cooper).permit(
      :fname,
      :lname,
      :house_id,
      :number,
      :uid,
      :current_member,
    )
  end
end
