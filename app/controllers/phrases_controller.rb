class PhrasesController < ApplicationController
  before_action :lookup_cooper
  before_action :verify_current_user

  def index
    @phrases = @cooper.phrases.all
  end

  def create
    phrase = @cooper.phrases.new(phrase_params)

    if phrase.valid?
      flash[:success] = "Your phrase has been added!"
      phrase.save
    else
      flash[:error] = phrase.errors.full_messages
    end

    redirect_to cooper_phrases_path(@cooper)
  end

  def destroy
    Phrase.find(params[:id]).destroy
    flash[:success] = "Phrase has been removed!"
    redirect_to cooper_phrases_path(@cooper)
  end

  private

  def lookup_cooper
    @cooper ||= Cooper.find(params[:cooper_id])
  end

  def phrase_params
    params.require(:phrase).permit(:text)
  end
end
