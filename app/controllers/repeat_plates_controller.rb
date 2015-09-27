class RepeatPlatesController < ApplicationController
  def create
    @cooper = Cooper.find(params[:cooper_id])
    day = params[:day].to_i

    unless @cooper.has_repeat_plate_for(day)
      @cooper.repeat_plates.create(day: day)
    end

    redirect_to root_path, flash: { success: "Weekly late plate added" }
  end

  def destroy
    plate = RepeatPlate.find(params[:id])
    plate.destroy

    redirect_to root_path, flash: { success: "Weekly late plate removed" }
  end
end
