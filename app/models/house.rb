class House < ActiveRecord::Base
  has_many :coopers

  module Mosaic
    ALL = [
      THE_ZOOO = "The Zooo".freeze,
      THE_TREEHOUSE = "The Treehouse".freeze,
    ]
  end

  scope :foster, -> { find_by( name: Mosaic::THE_ZOOO ) }
  scope :elmwood, -> { find_by( name: Mosaic::THE_TREEHOUSE  ) }

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
