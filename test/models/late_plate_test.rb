require 'test_helper'

class LatePlateTest < ActiveSupport::TestCase
  test "gets plate for particular house" do
    f = (0..10).to_a.sample
    e = f + 2

    fc = Cooper.create(fname: "f", lname: "f", house: "Foster", number: "+12223334464")
    ec = Cooper.create(fname: "e", lname: "e", house: "Elmwood", number: "+12223334444")

    f.times do |i|
      fc.late_plates.create( dt: DateTime.now + i )
    end

    e.times do |i|
      ec.late_plates.create( dt: DateTime.now + i )
    end

    assert_equal f, LatePlate.for_foster.count
    assert_equal e, LatePlate.for_elmwood.count
  end

  test "gets upcoming lateplates" do
    today = [1,2,3,4,5].sample
    today.times { LatePlate.create }

    upcoming = [2,3,4,5].sample
    upcoming.times { LatePlate.create( dt: DateTime.now + [1,2,3].sample ) }

    assert_equal upcoming, LatePlate.upcoming.count
    assert LatePlate.upcoming.first.dt < LatePlate.upcoming.second.dt
  end

  test "the same cooper can't have 2 late plates for the same day" do
    cooper = Cooper.create(fname: "f", lname: "f", house: "Foster", number: "+12223334464")
    cooper.late_plates.create( dt: DateTime.now.beginning_of_day )
    assert_no_difference -> { cooper.late_plates.count } do
      cooper.late_plates.create
    end
    assert_difference -> {cooper.late_plates.count }, +1 do
      cooper.late_plates.create( dt: DateTime.now + 2 )
    end
  end
end
