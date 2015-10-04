require 'twilio-ruby'
require 'chronic'
require 'late_plates_helper'

class LatePlatesController < ApplicationController
  def twilio_endpoint
    from_number = params[:From]
    message_body = params[:Body]

    message = MessagesService.respond_to_message(from_number, message_body)

    twiml = Twilio::TwiML::Response.new { |r| r.Message(message) }

    render xml: twiml.to_xml, layout: false
  end

  def index
    @foster_plates  = House.foster.all_plates_for_today
    @elmwood_plates = House.elmwood.all_plates_for_today

    @today = DateTime.now.readable

    if current_user
      @upcoming = current_user.house.upcoming_plates
    end
  end

  def help
    @undo = MessagesService.messages_config[:undo][:triggers]
    @help = MessagesService.messages_config[:help][:triggers]
    @status = MessagesService.messages_config[:status][:triggers]
  end

  def api
    @plates = all_plates_for_today
    render json: [@plates.map { |p| p.cooper.initialized_name }]
  end

  def create
    if current_user
      if current_user.late_plates.create
        flash[:success] = "Late plate added for today!"
      else
        flash[:error] = "You already have a late plate for today"
      end
      redirect_to root_path
    else
      # they gotta sign in
      redirect_to "/auth/google_oauth2"
    end
  end

  def destroy
    late_plate = LatePlate.find(params[:id])
    late_plate.destroy

    flash[:success] = "Your late plate has been removed"

    redirect_to root_path
  end
end
