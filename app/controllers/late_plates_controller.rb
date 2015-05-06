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
    @today = simple_time(DateTime.now)
    @upcoming = LatePlate.upcoming
  end

  def help
    @undo = UNDO_COMMANDS
    @help = HELP_COMMANDS
    @status = STATUS_COMMANDS
  end

  def api
    @plates = LatePlate.for_today
    render json: [@plates.map { |p| p.cooper.initialized_name }]
  end
end
