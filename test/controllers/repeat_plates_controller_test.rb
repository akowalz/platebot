require 'test_helper'

class RepeatPlatesControllerTest < ActionController::TestCase
  def setup
    @cooper = Cooper.create({
        fname: "Foo",
        lname: "Bar",
        house: "Foster",
        number: "+144455566666",
        uid:    "123abc"
    })
  end

  def tearday
    @cooper.destroy
  end

  test "create creates late plate on that day" do
    day = (0..4).to_a.sample
    assert_difference -> { @cooper.repeat_plates.count }, +1 do
      post :create, { cooper_id: @cooper.id.to_s,
                      day: day }
    end
    assert @cooper.has_repeat_plate_for(day), "Cooper should have plate for #{day}"
  end

  test "create should not add a late plate if cooper already has one that day" do
    day = (0..4).to_a.sample
    @cooper.repeat_plates.create(day: day)
    assert_no_difference -> { @cooper.repeat_plates.count } do
      post :create, { cooper_id: @cooper.id.to_s,
                      day: day }
    end
  end

  test "destroy removes a repeate plate for that day" do
    day = (0..4).to_a.sample
    @cooper.repeat_plates.create(day: day)
    plate_id = @cooper.repeat_plates.last.id.to_s
    assert_difference -> { @cooper.repeat_plates.count }, -1 do
      delete :destroy, { cooper_id: @cooper.id.to_s,
                         id: plate_id }
    end
    assert_not @cooper.has_repeat_plate_for(day)
  end

  test "it swaps a single plate for a repeat plate" do
    skip
    # this is a tricky case
    @cooper.late_plates.create
    assert @cooper.has_plate_for_today

    post :create, { cooper_id: @cooper.id.to_s,
                    day: DateTime.now.wday }
    assert @cooper.has_plate_for_today
    assert_not @cooper.has_single_plate_for_today
    assert @cooper.has_repeat_plate_for_today
  end
end
