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
end
