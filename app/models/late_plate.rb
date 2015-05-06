class LatePlate < ActiveRecord::Base
  belongs_to :cooper
  before_save :verify_late_plate

  def simple_time_with_date
    self.created_at
      .in_time_zone("Central Time (US & Canada)")
      .strftime("%l:%M %P on %A, %B %e")
  end

  def simple_time_for_day
    self.dt.strftime("%A, %B %e")
  end

  def self.for_today
    self.for_day(DateTime.now)
  end

  def self.for_day(day)
    where({ dt: (day.beginning_of_day..day.end_of_day) })
  end

  def self.upcoming
    where(" dt >= ?", DateTime.now.end_of_day).order(:dt)
  end

  def self.for_foster
    joins(:cooper).where("coopers.house LIKE ?", "Foster")
  end

  def self.for_elmwood
    joins(:cooper).where("coopers.house LIKE ?", "Elmwood")
  end

  private

  def verify_late_plate
    self.dt ||= DateTime.now
    return false if cooper && cooper.has_plate_for_day(self.dt)
  end
end
