class RepeatPlate < ActiveRecord::Base
  belongs_to :cooper
  validates_presence_of :day, :cooper_id
  validate :check_for_duplicate

  scope :for_today, -> { for_day(DateTime.now) }
  scope :for_house, -> house { joins(:cooper).where("coopers.house_id = ?", house.id) }
  scope :for_foster, -> { for_house(House.foster) }
  scope :for_elmwood, -> { for_house(House.elmwood) }

  def self.for_day(day)
    day = day.wday if day.is_a? DateTime
    where( day: day )
  end

  def simple_time_with_date
    self.created_at
      .in_time_zone("Central Time (US & Canada)")
      .strftime("%l:%M %P on %A, %B %e")
  end

  def check_for_duplicate
    if cooper.has_repeat_plate_for(day)
      errors.add(:cooper, "Cooper already has plate for that day")
    end
  end
end
