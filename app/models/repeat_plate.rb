class RepeatPlate < ActiveRecord::Base
  belongs_to :cooper
  validates_presence_of :day, :cooper_id
  validate :check_for_duplicate

  def self.for_day(day)
    day = day.wday if day.is_a? DateTime
    where( day: day )
  end

  def simple_time_with_date
    self.created_at
      .in_time_zone("Central Time (US & Canada)")
      .strftime("%l:%M %P on %A, %B %e")
  end

  def self.for_today
    self.for_day(DateTime.now)
  end

  def self.for_foster
    joins(:cooper).where("coopers.house LIKE ?", "Foster")
  end

  def self.for_elmwood
    joins(:cooper).where("coopers.house LIKE ?", "Elmwood")
  end

  def check_for_duplicate
    if cooper.has_repeat_plate_for(day)
      errors.add(:cooper, "Cooper already has plate for that day")
    end
  end
end
