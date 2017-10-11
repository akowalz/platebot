class SmsConfirmationsController < ApplicationController
  before_action { @cooper = Cooper.find(params[:cooper_id]) }

  def new
  end

  def create
    if confirmation_params[:sms_confirmation_code] == @cooper.sms_confirmation_code
      @cooper.update_attributes(sms_confirmed: true)

      flash[:success] = "Success! Platebot now knows your number. Text Platebot 'status' to test it out"
      redirect_to root_path
    else
      flash[:error] = "Sorry, that code isn't correct. Please try again"
      redirect_to new_cooper_sms_confirmation_path(@cooper)
    end
  end

  private

  def confirmation_params
    params.require(:cooper).permit(:sms_confirmation_code)
  end
end
