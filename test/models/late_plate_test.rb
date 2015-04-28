require 'test_helper'

class LatePlateTest < ActiveSupport::TestCase
  test "gets plate for particular house" do
    f = (0..10).to_a.sample
    e = f + 2

    fc = Cooper.create(fname: "f", lname: "f", house: "Foster", number: "+12223334464")
    ec = Cooper.create(fname: "e", lname: "e", house: "Elmwood", number: "+12223334444")

    f.times do
      fc.late_plates.create( dt: DateTime.now )
    end

    e.times do
      ec.late_plates.create( dt: DateTime.now )
    end

    assert_equal f, LatePlate.for_today.for_foster.count
    assert_equal e, LatePlate.for_today.for_elmwood.count
  end

  test "gets upcoming lateplates" do
    today = [1,2,3,4,5].sample
    today.times { LatePlate.create }

    upcoming = [2,3,4,5].sample
    upcoming.times { LatePlate.create( dt: DateTime.now + [1,2,3].sample ) }

    assert_equal upcoming, LatePlate.upcoming.count
    assert LatePlate.upcoming.first.dt < LatePlate.upcoming.second.dt
  end
end
