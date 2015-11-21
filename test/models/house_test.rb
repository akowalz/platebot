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
end
