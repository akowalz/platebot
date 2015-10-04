class LatePlate < ActiveRecord::Base
  belongs_to :cooper
  validates_presence_of :cooper_id, :dt
  before_validation { self.dt ||= DateTime.now }
  validate :verify_late_plate

  scope :upcoming, -> { where(" dt >= ?", DateTime.now.end_of_day).order(:dt) }
  scope :for_day, -> day { where({ dt: (day.beginning_of_day..day.end_of_day) }) }
  scope :for_today, -> { for_day(DateTime.now) }
  scope :for_house, -> house { joins(:cooper).where("coopers.house_id = ?", house.id) }
  scope :for_foster, -> { for_house(House.foster) }
  scope :for_elmwood, -> { for_house(House.elmwood) }

  def simple_time_with_date
    self.created_at
      .in_time_zone("Central Time (US & Canada)")
      .strftime("%l:%M %P on %A, %B %e")
  end

  def simple_time_for_day
    self.dt.readable
  end

  private

  def verify_late_plate
    if cooper && cooper.has_plate_for_day(self.dt)
      errors.add(:duplicate_plate, "Cannot have two late plates on one day")
    end
  end
end
