class Cooper < ActiveRecord::Base
  has_many :late_plates, dependent: :destroy
  before_validation { self.number = Cooper.clean_number(self.number) }

  validates :fname, { presence: true }
  validates :lname, { presence: true }
  validates :number, { uniqueness: true }
  validates_format_of :number, { with: /\+1\d{10}/ }
  validates_format_of :house, { with: /(Foster)|(Elmwood)/ }

  def Cooper.find_by_uncleaned_number(number)
    number = Cooper.clean_number(number)
    Cooper.find_by_number(number)
  end

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

  def Cooper.clean_number(number)
    number.gsub!(/[^\d\+]/,'')
    number = "+1" + number if number[0..1] != "+1"
    number
  end
end
