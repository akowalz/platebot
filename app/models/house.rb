class House < ActiveRecord::Base
  has_many :coopers

  scope :foster, -> { find_by( name: "The Zooo" ) }
  scope :elmwood, -> { find_by( name: "The Treehouse" ) }

  def all_plates_for_today
    daily_plates_for_today + repeat_plates_for_today
  end

  def upcoming_plates
    LatePlate.for_house(self).upcoming
  end

  private

  def daily_plates_for_today
    LatePlate.for_house(self).for_today
  end

  def repeat_plates_for_today
    RepeatPlate.for_house(self).for_today
  end
end
