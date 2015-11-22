class MessagesService
  class << self
    include ActionView::Helpers::TextHelper

    def respond_to_message(from, body)
      unless cooper = Cooper.find_by(number: from)
        return "Sorry, I don't recognize this number.  Add it at plate-bot.com"
      end

      _config.each do |key, data|
        if body_triggers_command?(body, data[:triggers])
          return send("handle_#{key}_command", cooper)
        end
      end

      handle_unknown_message(cooper, body)
    end

    def _config
      @config ||= YAML.load_file(File.join(Rails.root, "config", "messages.yml")).with_indifferent_access
    end

    def body_triggers_command?(body, triggers)
      body = body.downcase.strip.gsub(/[^\w\s]/,'')
      triggers.any? { |trigger| trigger == body }
    end

    def handle_status_command(cooper)
      if cooper.has_plate_for_today
        _config[:status][:positive_response] % { name: cooper.fname }
      else
        _config[:status][:negative_response] % { name: cooper.fname }
      end
    end

    def handle_fetch_command(cooper)
      plates = cooper.house.all_plates_for_today

      if plates.empty?
        _config[:fetch][:no_plates] % {
          house: cooper.house.name,
        }
      else
        _config[:fetch][:response] % {
          is_are: plates.length == 1 ? 'is' : 'are',
          count: pluralize(plates.count, "plate"),
          house: cooper.house.name,
          names: plates.map { |plate| plate.cooper.fname }.join(", ")
        }
      end
    end

    def handle_help_command(cooper)
      return _config[:help][:response]
    end

    def handle_undo_command(cooper)
      plate_to_remove = cooper.late_plates.last
      if plate_to_remove
        date = cooper.late_plates.last.date
        plate_to_remove.destroy
        _config[:undo][:positive_response] % {
          name: cooper.fname,
          date: date.readable,
          nice_phrase: nice_phrase
        }
      else
        _config[:undo][:negative_response] % { name: cooper.fname }
      end
    end

    def handle_add_command(cooper)
      _add_late_plate_for_day(cooper, Date.today)
    end

    def handle_unknown_message(cooper, message)
      parsed_date = Chronic.parse(message)
      if parsed_date.nil?
        _config[:unknown][:response]
      else
        date = parsed_date.to_date
        _add_late_plate_for_day(cooper, date)
      end

    end

    def _add_late_plate_for_day(cooper, date)
      if cooper.has_plate_for_day(date)
        _config[:add][:negative_response] % {
          name: cooper.fname,
          date: date.readable,
        }
      else
        cooper.late_plates.create( date: date )
        _config[:add][:positive_response] % {
          name: cooper.fname,
          date: date.readable,
          nice_phrase: nice_phrase
        }
      end
    end

    def nice_phrase
      ([
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
      ] + Phrase.all.map(&:text)).sample
    end
  end
end
