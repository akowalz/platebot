class TwilioClient
  class << self
    TWILIO_ACCOUNT_SID = ENV["TWILIO_ACCOUNT_SID"]
    TWILIO_AUTH_TOKEN = ENV["TWILIO_AUTH_TOKEN"]
    FROM_NUMBER = ENV["PLATEBOT_FROM_NUMBER"]

    def send_message(message, number)
      client.account.messages.create(
        body: message,
        to: number,
        from: FROM_NUMBER,
      ) if Rails.env.production?

      Rails.logger.info("Sent text message '#{message}' to #{number} via Twilio")
    end

    def client
      @client ||= Twilio::REST::Client.new(
        TWILIO_ACCOUNT_SID,
        TWILIO_AUTH_TOKEN,
      )
    end
  end
end
