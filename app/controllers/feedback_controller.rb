class FeedbackController < ApplicationController
  def new
    redirect_to root_path unless current_user
  end

  def create
    ActionMailer::Base.mail({
      from: params.fetch(:email, "no-reply@platebot.com"),
      to: "askowalczuk93@gmail.com",
      subject: "[PlateBot Feedback]",
      body: params[:feedback]
    }).deliver_now

    flash[:success] = "Thanks for your feedback! Your input is appreciated."
    redirect_to root_path
  end
end
