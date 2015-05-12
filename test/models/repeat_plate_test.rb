require 'test_helper'

class RepeatPlateTest < ActiveSupport::TestCase
  def setup
    @cooper = Cooper.create({
        fname: "Foo",
        lname: "Bar",
        house: "Foster",
        number: "+14445556666",
        uid:    "123abc"
    })
  end

  def teardown
    @cooper.destroy
  end

  test "gets for a particular day" do
    day = (0..4).to_a.sample
    @cooper.repeat_plates.create(day: day)
    assert_equal 1, @cooper.repeat_plates.for_day(day).count
  end

  test "does not add a repeat plate for cooper on same day as another" do
    day = (0..4).to_a.sample
    @cooper.repeat_plates.create(day: day)
    assert_no_difference -> { @cooper.repeat_plates.count } do
      @cooper.repeat_plates.create(day: day)
    end
  end
end
