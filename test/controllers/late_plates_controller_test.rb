require 'test_helper'

class LatePlatesControllerTest < ActionController::TestCase
  def setup
    @cooper = Cooper.create( {
      fname: "Bob",
      lname: "Smith",
      house: "Foster",
      number: "+11235556666"
    })
  end

  def teardown
    @cooper.destroy
  end

  test "adds late plates for coopers" do
    assert_difference -> { LatePlate.count } do
      post :add, { From: @cooper.number, Body: "Today" }
    end
    assert @cooper.late_plates.count > 0
  end

  test "does not add plate for strangers" do
    assert_no_difference -> { LatePlate.count } do
      post :add, { From: "+5235556666", Body: "Today" }
    end
    assert @cooper.late_plates.count == 0
  end

  test "adds late plates for tomorrow" do
    post :add, From: @cooper.number, Body: "Tomorrow"

    assert @cooper.late_plates.last.dt > Time.now,
      "Time was #{@cooper.late_plates.last.dt}"
  end

  test "adds late plates with command" do
    assert_difference -> { LatePlate.count } do
      post :add, { From: @cooper.number, Body: "late plate" }
    end
    assert LatePlate.last.dt <= DateTime.now
  end

  test "does not add late plate twice" do
    @cooper.late_plates.create( dt: DateTime.now )
    assert_no_difference -> { LatePlate.count } do
      post :add, { From: @cooper.number, Body: "today" }
    end
    assert_select "Message", /already/
  end

  test "does not break when given bad date" do
    assert_no_difference -> { @cooper.late_plates.count } do
      post :add, { From: @cooper.number, Body: "adlghalsdhg" }
    end
    assert_select "Message", /sorry/i
  end

  test "removes coopers most recent late plate when given command" do
    @cooper.late_plates.create( dt: DateTime.now )
    assert_difference -> { @cooper.late_plates.count }, -1 do
      post :add, { From: @cooper.number, Body: "Undo" }
    end
    assert_select "Message", /removed/i
  end

  test "let's cooper know there was no plate to destroy" do
    assert_no_difference -> { @cooper.late_plates.count }, -1 do
      post :add, { From: @cooper.number, Body: "remove" }
    end
    assert_select "Message", /don't/
  end

  test "status returns if the cooper has a late plate today" do
    @cooper.late_plates.create( dt: DateTime.now )
    @cooper.late_plates.create( dt: DateTime.now.tomorrow )
    assert_no_difference -> { @cooper.late_plates.count } do
      post :add, { From: @cooper.number, Body: "  Status" }
    end
    assert_select "Message", /a late plate/
  end

  test "status returns if cooper has no late plate today" do
    @cooper.late_plates.create( dt: DateTime.now.tomorrow )
    assert_no_difference -> { @cooper.late_plates.count } do
      post :add, { From: @cooper.number, Body: "Status" }
    end
    assert_select "Message", /don't/
  end

  test "help returns some help options" do
    assert_no_difference -> { @cooper.late_plates.count } do
      post :add, { From: @cooper.number, Body: "howto  " }
    end
    assert_select "Message", /status/
  end

  test "index lists today's late plates" do
    n = [1,2,3,4].sample
    n.times do
      @cooper.late_plates.create( dt: DateTime.now )
    end

    get :index
    assert_response 200
    assert_select ".late-plate", count: n
  end

  test "index does not list tomorrow's late plates" do
    n = [1,2,3,4].sample
    n.times do
      @cooper.late_plates.create( dt: DateTime.now )
    end

    @cooper.late_plates.create( dt: DateTime.now.tomorrow )
    @cooper.late_plates.create( dt: DateTime.now.yesterday )

    get :index
    assert_response 200
    assert_select ".late-plate", count: n
  end
end
