module Api
  class CoopersController < ApplicationController
    before_action :lookup_cooper, only: [:edit, :update]

    def update
      if @cooper.update_attributes(cooper_params)
        render json: {cooper: @cooper.as_json}
      else
        render json: {cooper: @cooper.as_json, errors: @cooper.errors.as_json}, status: 422
      end
    end

    private

    def lookup_cooper
      @cooper = Cooper.find(params[:id])
    end

    def cooper_params
      params.require(:cooper).permit(
        :fname,
        :lname,
        :house_id,
        :number,
        :uid,
        :current_member,
        :admin,
      )
    end
  end
end
