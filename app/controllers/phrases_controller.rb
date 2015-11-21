class PhrasesController < ApplicationController
  before_action :verify_cooper

  def index
    @phrases = _cooper.phrases.all
  end

  def create
    phrase = _cooper.phrases.new(phrase_params)

    if phrase.valid?
      flash[:success] = "Your phrase has been added!"
      phrase.save
    else
      flash[:error] = phrase.errors.full_messages
    end

    redirect_to cooper_phrases_path(_cooper)
  end

  def destroy
    Phrase.find(params[:id]).destroy
    flash[:success] = "Phrase has been removed!"
    redirect_to cooper_phrases_path(_cooper)
  end

  def verify_cooper
    unless current_user && current_user == _cooper
      flash[:warning] = "Please sign in first!"
      redirect_to root_path
    end
  end

  def _cooper
    @cooper ||= Cooper.find(params[:cooper_id])
  end

  def phrase_params
    params.require(:phrase).permit(:text)
  end
end
