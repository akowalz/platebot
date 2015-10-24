require 'test_helper'

class LatePlateTest < ActiveSupport::TestCase
  def setup
    @cooper = FactoryGirl.create(:cooper)
    @elmwooder = FactoryGirl.create(:elmwooder)
  end

  def teardown
    @cooper.destroy
  end

  test "gets late plates for a particular house" do
    assert LatePlate.for_house(@cooper.house).empty?
    @cooper.late_plates.create!
    assert_equal LatePlate.for_house(@cooper.house).count, 1
    @elmwooder.late_plates.create!
    assert_equal LatePlate.for_house(@elmwooder.house).count, 1
    assert_equal LatePlate.for_house(@cooper.house).count, 1
  end

  test "gets late plates for a particular day" do
    @cooper.late_plates.create( date: Date.today + 100 )
    assert_equal LatePlate.for_day( Date.today + 100 ).count, 1
  end

  test "gets for a particular house on a particular day" do
    @elmwooder.late_plates.create( date: Date.today + 100)
    assert_equal LatePlate.for_house(@elmwooder.house).for_day( Date.today + 100).count, 1

  end

  test "gets upcoming lateplates" do
    upcoming = [2,3,4,5].sample
    upcoming.times { |i| @cooper.late_plates.create( date: Date.today + i+1 ) }

    assert_equal upcoming, LatePlate.upcoming.count
    assert LatePlate.upcoming.first.date < LatePlate.upcoming.second.date
  end

  test "the same cooper can't have 2 late plates for the same day" do
    @cooper.late_plates.create( date: Date.tomorrow )
    assert_no_difference -> { @cooper.late_plates.count } do
      @cooper.late_plates.create( date: Date.tomorrow )
    end
    assert_difference -> { @cooper.late_plates.count }, +1 do
      @cooper.late_plates.create( date: Date.today + 2 )
    end
  end
end
