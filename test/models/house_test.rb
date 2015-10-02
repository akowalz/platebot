require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  def setup
    @foster = House.foster
    @elmwood = House.elmwood
    @cooper = FactoryGirl.create(:cooper)
    @elmwooder = FactoryGirl.create(:elmwooder)
  end

  test "gets daily late plates for a house" do
    assert @foster.daily_plates_for_today.empty?

    @cooper.late_plates.create!
    assert_equal @foster.daily_plates_for_today.count, 1

    @elmwooder.late_plates.create!
    assert_equal @elmwood.daily_plates_for_today.count, 1
    assert_equal @foster.daily_plates_for_today.count, 1
  end

  test "gets upcoming plates" do
    n = rand(10)
    n.times { |i| @cooper.late_plates.create( dt: (i+1).days.from_now ) }
    assert_equal @foster.upcoming_plates.count, n
  end
end
