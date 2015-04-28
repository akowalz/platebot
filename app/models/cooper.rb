class Cooper < ActiveRecord::Base
  has_many :late_plates, dependent: :destroy
  before_validation :sanitize_number

  validates :fname, { presence: true }
  validates :lname, { presence: true }
  validates :number, { uniqueness: true }
  validates_format_of :number, { with: /\+1\d{10}/ }
  validates_format_of :house, { with: /(Foster)|(Elmwood)/ }

  def has_plate_for_day(day)
    late_plates.for_day(day).count > 0
  end

  def has_plate_for_today
    has_plate_for_day(DateTime.now)
  end

  def name
    self.fname
  end

  def initialized_name
    "#{self.fname} #{self.lname[0]}."
  end

  def sanitize_number
    self.number.gsub!(/[^\d\+]/,'')
    self.number = "+1" + self.number if self.number[0..1] != "+1"
  end
end
