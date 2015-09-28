require 'test_helper'

class LatePlateTest < ActiveSupport::TestCase
  def setup
    @cooper = Cooper.create({
      fname: "Bob",
      lname: "Smith",
      house_id: House.first.id,
      number: "+11235556666",
      uid: "123uid",
    })

    @elmwooder = Cooper.create({
      fname: "Jim",
      lname: "Dale",
      house_id: House.second.id,
      number: "+11235236666",
      uid: "123uida",
    })
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
    @cooper.late_plates.create( dt: DateTime.now + 100 )
    assert_equal LatePlate.for_day( DateTime.now + 100 ).count, 1
  end

  test "gets for a particular house on a particular day" do
    @elmwooder.late_plates.create( dt: DateTime.now + 100)
    assert_equal LatePlate.for_house(@elmwooder.house).for_day( DateTime.now + 100).count, 1

  end

  test "gets upcoming lateplates" do
    upcoming = [2,3,4,5].sample
    upcoming.times { |i| @cooper.late_plates.create( dt: DateTime.now + i+1 ) }

    assert_equal upcoming, LatePlate.upcoming.count
    assert LatePlate.upcoming.first.dt < LatePlate.upcoming.second.dt
  end

  test "the same cooper can't have 2 late plates for the same day" do
    @cooper.late_plates.create( dt: DateTime.now.beginning_of_day )
    assert_no_difference -> { @cooper.late_plates.count } do
      @cooper.late_plates.create
    end
    assert_difference -> { @cooper.late_plates.count }, +1 do
      @cooper.late_plates.create( dt: DateTime.now + 2 )
    end
  end
end
