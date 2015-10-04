class TextSimController < ApplicationController
  def new
    redirect_to root_path unless Rails.env.development?
  end
end
