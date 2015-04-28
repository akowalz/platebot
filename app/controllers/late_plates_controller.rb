require 'twilio-ruby'
require 'chronic'

class LatePlatesController < ApplicationController

  UNDO_COMMANDS = ["undo", "delete", "remove", "remove plate", "remove late plate"]
  HELP_COMMANDS = ["howto", "how to", "assist", "halp", "how"]
  ADD_COMMANDS =  ["add", "new", "late plate", "late", "plate"]
  STATUS_COMMANDS = ["status", "check"]

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

  private

    def create_message(from, body)
      unless cooper = Cooper.find_by({ number: from })
        return "Sorry, I don't recognize this number. Add it at plate-bot.com"
      end

      if is_help_command(body)
        return "Try something like...:\n" +
                "'Today' - add a late plate for today\n" +
                "'friday' - add a late for Friday\n" +
                "'status' - check if you have a plate tonight\n" +
                "'undo' - remove your most recent addition"

      elsif is_status_command(body)
        if cooper.has_plate_for_today
          return "#{cooper.name}, you have a late plate added for today, #{simple_time(DateTime.now)}"
        else
          return "#{cooper.name}, you don't have a late plate for today! Text 'today' to add one!"
        end

      elsif is_undo_command(body)
        plate = cooper.late_plates.last
        if plate
          dt = cooper.late_plates.last.dt
          cooper.late_plates.last.destroy
          return "Got it, #{cooper.name}, your plate for #{simple_time(dt)} was removed!"
        else
          return "You don't currently have any late plates, so there's nothing to remove!"
        end

      elsif is_add_command(body)
        time = DateTime.now

      else
        parsed_date = Chronic.parse(body)
        if parsed_date.nil?
          return "Sorry, #{cooper.name}, I didn't get that.  Text 'howto' to see what I understand!"
        end

        # gotta convert from Time to DateTime
        time = DateTime.parse(parsed_date.to_s)
      end

      if !cooper.has_plate_for_day(time)
        cooper.late_plates.create( { dt: time } )
        return "Hello, #{cooper.name}! Your late plate has been added for #{simple_time(time)}!" +
               "You can undo this by texting 'undo'. #{nice_phrase}"
      else
        return "#{cooper.name}, you already have a late plate for #{simple_time(time)}"
      end
    end

    def check_command(text, commands)
      text = text.downcase.strip.gsub(/[^\w\s]/,'')
      commands.any? { |command| command == text }
    end

    def nice_phrase
      [
        "Have a great day!",
        "You're awesome!",
        "Keep doin' you!",
        "Have a fantastic day!",
        "Hope you like vegetarian!",
        "Yum yum yum !!!",
        "Keep on truckin'!",
        "Co-op-tastic!"
      ].sample
    end

    def simple_time(time)
      time.strftime("%A, %B %e")
    end

    def is_add_command(text)
      check_command(text, ADD_COMMANDS)
    end

    def is_undo_command(text)
      check_command(text, UNDO_COMMANDS)
    end

    def is_status_command(text)
      check_command(text, STATUS_COMMANDS)
    end

    def is_help_command(text)
      check_command(text, HELP_COMMANDS)
    end
end
