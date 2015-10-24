class LatePlate < ActiveRecord::Base
  belongs_to :cooper
  validates_presence_of :cooper_id, :date
  before_validation { self.date ||= Date.today }
  validate :verify_late_plate

  scope :upcoming, -> { where(" date >= ?", Date.today).order(:date) }
  scope :for_day, -> day { where({ date: day }) }
  scope :for_today, -> { for_day(Date.today) }
  scope :for_house, -> house { joins(:cooper).where("coopers.house_id = ?", house.id) }
  scope :for_foster, -> { for_house(House.foster) }
  scope :for_elmwood, -> { for_house(House.elmwood) }

  def simple_time_with_date
    self.created_at
      .in_time_zone("Central Time (US & Canada)")
      .strftime("%l:%M %P on %A, %B %e")
  end

  def simple_time_for_day
    date.readable
  end

  private

  def verify_late_plate
    if cooper && cooper.has_plate_for_day(self.date)
      errors.add(:duplicate_plate, "Cannot have two late plates on one day")
    end
  end
end
