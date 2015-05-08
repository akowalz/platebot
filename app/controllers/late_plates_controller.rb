require 'twilio-ruby'
require 'chronic'
require 'late_plates_helper'

class LatePlatesController < ApplicationController
  include LatePlatesHelper

  def add
    from_number = params[:From]
    message_body = params[:Body]

    message = create_message(from_number, message_body)

    twiml = Twilio::TwiML::Response.new { |r| r.Message(message) }

    render xml: twiml.to_xml, layout: false
  end

  def index
    @plates = LatePlate.for_today
    @repeats = RepeatPlate.for_today
    @today = simple_time(DateTime.now)
    @upcoming = LatePlate.upcoming
  end

  def help
    @undo = UNDO_COMMANDS
    @help = HELP_COMMANDS
    @status = STATUS_COMMANDS
  end

  def api
    @plates = LatePlate.for_today + RepeatPlate.for_today
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
