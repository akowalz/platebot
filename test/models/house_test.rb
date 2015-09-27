require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  def setup
    @foster = House.first
    @elmwood = House.second
    @cooper = Cooper.create( {
      fname: "Bob",
      lname: "Smith",
      number: "+11235556666",
      house_id: House.first.id,
      uid: "123uid"
    })
    @elmwooder = Cooper.create( {
      fname: "Bob",
      lname: "Smith",
      number: "+11235556966",
      house_id: House.second.id,
      uid: "123uidadf"
    })
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
