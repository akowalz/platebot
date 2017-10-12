require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  def setup
    @foster = House.foster
    @elmwood = House.elmwood
    @cooper = FactoryGirl.create(:cooper)
    @elmwooder = FactoryGirl.create(:elmwooder)
  end

  test "gets all late plates for a house" do
    assert @foster.all_plates_for_today.empty?

    @cooper.late_plates.create!
    assert_equal @foster.all_plates_for_today.count, 1

    @elmwooder.late_plates.create!
    assert_equal @elmwood.all_plates_for_today.count, 1
    assert_equal @foster.all_plates_for_today.count, 1
  end
end
