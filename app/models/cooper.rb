class Cooper < ActiveRecord::Base
  has_many :late_plates,   dependent: :destroy
  has_many :repeat_plates, dependent: :destroy
  has_many :phrases,       dependent: :destroy
  belongs_to :house

  before_validation { self.number = Cooper.clean_number(self.number) }
  before_create { self.activation_code = rand(9999).to_s.rjust(4, "0") }

  validates :fname, { presence: true }
  validates :lname, { presence: true }
  validates :number, { uniqueness: true }
  validates_format_of :number, { with: /\A\+1\d{10}\z/ }

  # all plates
  def has_plate_for_day(day)
    has_single_plate_for_day(day) ||
    has_repeat_plate_for(day.wday)
  end

  def has_plate_for_today
    has_plate_for_day(Date.today)
  end

  # repeat plates
  def has_repeat_plate_for(day)
    repeat_plates.for_day(day).count > 0
  end

  def has_repeat_plate_for_today
    has_repeat_plate_for(Date.today)
  end

  # single plates
  def has_single_plate_for_day(day)
    late_plates.for_day(day).count > 0
  end

  def has_single_plate_for_today
    has_single_plate_for_day(Date.today)
  end

  def name
    self.fname
  end

  def initialized_name
    "#{self.fname} #{self.lname[0]}."
  end

  def lives_in_foster?
    house == House.foster
  end

  def lives_in_elmwood?
    house == House.elmwood
  end

  def Cooper.clean_number(number)
    number.gsub!(/[^\d\+]/,'')
    number = "+1" + number if number[0..1] != "+1"
    number
  end

  def Cooper.find_by_uncleaned_number(number)
    number = Cooper.clean_number(number)
    Cooper.find_by_number(number)
  end

end
