require 'twilio-ruby'

class CoopersController < ApplicationController

  def create
    if @cooper = Cooper.find_by_uncleaned_number(cooper_params[:number])
      # this cooper used the old login system, they just gotten link their account
      @cooper.update_attributes(uid: cooper_params[:uid])
      flash[:success] = "Thanks #{@cooper.fname}! Your account has been linked and you're signed in! Woohoo!"

      sign_in(@cooper)

      redirect_to root_path
    else
      # this person is using the new login system, make a new record
      @cooper = Cooper.new(cooper_params)
      if @cooper.valid?
        @cooper.save

        flash[:success] = "Success! PlateBot now knows your number. Text PlateBot 'status' to test it out"
        sign_in(@cooper)

        redirect_to root_path
      else
        flash[:error] = @cooper.errors.full_messages

        redirect_to new_cooper_path
      end
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

  private
    def cooper_params
      params.require(:cooper).permit(
        :fname,
        :lname,
        :house,
        :number,
        :uid
      )
    end
end

