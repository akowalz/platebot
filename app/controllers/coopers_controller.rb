require 'twilio-ruby'

class CoopersController < ApplicationController
  def create
    @cooper = Cooper.new(cooper_params)
    if @cooper.valid?
      @cooper.save

      sign_in(@cooper)

      TwilioClient.send_message("Your Platebot confirmation code is #{@cooper.activation_code}", @cooper.number)

      redirect_to activation_cooper_path(@cooper)
    else
      flash[:error] = @cooper.errors.full_messages

      redirect_to new_cooper_path
    end
  end

  def edit
    @cooper = Cooper.find(params[:id])
  end

  def update
    @cooper = Cooper.find(params[:id])

    if @cooper.update_attributes(cooper_params)
      flash[:success] = "Your info has been updated!"
      redirect_to root_path
    else

      flash.now[:error] = @cooper.errors.full_messages
      render 'edit'
    end
  end

  def activation
    @cooper = Cooper.find(params[:id])
  end

  def activate
    @cooper = Cooper.find(params[:id])

    activation_code = activation_params[:activation_code]

    if activation_code == @cooper.activation_code
      @cooper.update_attributes(active: true)
      flash[:success] = "Success! Platebot now knows your number. Text Platebot 'status' to test it out"
      redirect_to root_path
    else
      flash[:error] = "Sorry, that activation code isn't correct. Please try again"
      redirect_to activation_cooper_path
    end
  end

  private
    def cooper_params
      params.require(:cooper).permit(
        :fname,
        :lname,
        :house_id,
        :number,
        :uid,
      )
    end

    def activation_params
      params.require(:cooper).permit(:activation_code)
    end
end
