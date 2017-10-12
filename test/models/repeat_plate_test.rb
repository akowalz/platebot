require 'test_helper'

class RepeatPlateTest < ActiveSupport::TestCase
  def setup
    @cooper = create(:cooper)
  end

  def teardown
    @cooper.destroy
  end

  test "gets for a particular day" do
    day = (0..4).to_a.sample
    @cooper.repeat_plates.create(day: day)
    assert_equal 1, @cooper.repeat_plates.for_day(day).count
  end

  test "#for_house only returns plates for current members" do
    inactive_cooper = create(:cooper)
    inactive_cooper.update_attributes(current_member: false)

    inactive_cooper.repeat_plates.create(day: Date.today.wday)

    assert_equal 0, RepeatPlate.for_house(inactive_cooper.house).count
  end

  test "does not add a repeat plate for cooper on same day as another" do
    day = (0..4).to_a.sample
    @cooper.repeat_plates.create(day: day)

    assert_no_difference -> { @cooper.repeat_plates.count } do
      @cooper.repeat_plates.create(day: day)
    end
  end
end
