class LatePlatesController < ApplicationController
  def twilio_endpoint
    from_number = params[:From]
    message_body = params[:Body]

    cooper = Cooper.find_by(number: from_number)
    if cooper.nil? || !cooper.sms_confirmed?
      render status: 403, body: nil, layout: false
      return
    end

    text = MessagesService.respond_to_message(cooper, message_body)

    twiml = Twilio::TwiML::MessagingResponse.new.message do |message|
      message.body(text)
    end

    render xml: twiml.to_xml, layout: false
  end

  def index
    @houses = House.all

    if current_user
      @upcoming = current_user.house.upcoming_plates
    end
  end

  def help
    @undo = MessagesService._config[:undo][:triggers]
    @help = MessagesService._config[:help][:triggers]
    @status = MessagesService._config[:status][:triggers]
    @fetch = MessagesService._config[:fetch][:triggers]
  end

  def create
    return redirect_to "/auth/google_oauth2/" unless current_user

    if !current_user.has_plate_for_today
      current_user.late_plates.create
      flash[:success] = "Late plate added for today!"
    else
      flash[:error] = "You already have a late plate for today"
    end

    redirect_to root_path
  end

  def destroy
    late_plate = LatePlate.find(params[:id])
    late_plate.destroy

    flash[:success] = "Your late plate has been removed"

    redirect_to root_path
  end
end
