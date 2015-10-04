class MessagesService
  class << self
    include ActionView::Helpers::TextHelper

    def respond_to_message(from, body)
      unless cooper = Cooper.find_by(number: from)
        return "Sorry, I don't recognize this number.  Add it at plate-bot.com"
      end

      messages_config.each do |key, data|
        if body_triggers_command?(body, data[:triggers])
          return send("handle_#{key}_command", cooper)
        end
      end

      handle_unknown_message(cooper, body)
    end

    def messages_config
      @config ||= YAML.load_file(File.join(Rails.root, "config", "messages.yml")).with_indifferent_access
    end

    def body_triggers_command?(body, triggers)
      body = body.downcase.strip.gsub(/[^\w\s]/,'')
      triggers.any? { |trigger| trigger == body }
    end

    def handle_status_command(cooper)
      if cooper.has_plate_for_today
        @config[:status][:positive_response] % { name: cooper.fname }
      else
        @config[:status][:negative_response] % { name: cooper.fname }
      end
    end

    def handle_fetch_command(cooper)
      all_plates = cooper.house.all_plates_for_today
      @config[:fetch][:response] % {
        is_are: all_plates.length == 1 ? 'is' : 'are',
        count: pluralize(all_plates.count, "plate"),
        house: cooper.house.name,
        names: all_plates.map { |plate| plate.cooper.fname }.join(",")
      }
    end

    def handle_help_command(cooper)
      return @config[:help][:response]
    end

    def handle_undo_command(cooper)
      plate_to_remove = cooper.late_plates.last
      if plate_to_remove
        date = cooper.late_plates.last.dt
        plate_to_remove.destroy
        @config[:undo][:positive_response] % {
          name: cooper.fname,
          date: date.readable,
          nice_phrase: nice_phrase
        }
      else
        @config[:undo][:negative_response] % { name: cooper.fname }
      end
    end

    def handle_add_command(cooper)
      _add_late_plate_for_day(cooper, DateTime.now)
    end

    def handle_unknown_message(cooper, message)
      parsed_date = Chronic.parse(message)
      if parsed_date.nil?
        @config[:unknown][:response]
      else
        date = DateTime.parse(parsed_date.to_s)
        _add_late_plate_for_day(cooper, date)
      end

    end

    def _add_late_plate_for_day(cooper, date)
      if cooper.has_plate_for_day(date)
        @config[:add][:negative_response] % {
          name: cooper.fname,
          date: date.readable,
        }
      else
        cooper.late_plates.create( dt: date )
        @config[:add][:positive_response] % {
          name: cooper.fname,
          date: date.readable,
          nice_phrase: nice_phrase
        }
      end
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
        "Treat yo self!",
        "It's gon' be good'",
        "Live long and prosper",
        "May the force be with you",
        "PlateBot OUT.",
        "Yabba dabba dooo!",
        "Happy trails!"
      ].sample
    end
  end
end
