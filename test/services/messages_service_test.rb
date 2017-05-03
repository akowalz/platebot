require 'test_helper'

class MessagesServiceTest < ActiveSupport::TestCase

  def setup
    @cooper = FactoryGirl.create(:cooper)
  end

  test "adds late plates for coopers" do
    assert_difference -> { LatePlate.count } do
      @response = MessagesService.respond_to_message(@cooper, "add")
    end

    assert_equal 1, @cooper.late_plates.count
    assert_match(/has been added/, @response)
    assert_match(@cooper.fname, @response)
    assert_match(Date.today.readable, @response)
  end

  test "does not add two late plates for one day" do
    @cooper.late_plates.create

    assert_no_difference -> { LatePlate.count } do
      @response = MessagesService.respond_to_message(@cooper, "add")
    end

    assert_match(/already/, @response)
  end

  test "removes most recent command with 'undo'" do
    @cooper.late_plates.create

    assert_difference -> { @cooper.late_plates.count }, -1 do
      @response = MessagesService.respond_to_message(@cooper, "undo")
    end

    assert_match(/removed/, @response)
    assert_match(Date.today.readable, @response)
  end

  test "does not try to remove plates that aren't there" do
    assert_no_difference -> { @cooper.late_plates.count } do
      @response = MessagesService.respond_to_message(@cooper, "undo")
    end

    assert_match(/don't have/, @response)
  end

  test "status returns if the cooper has a late plate today" do
    @cooper.late_plates.create( date: Date.today )

    response = MessagesService.respond_to_message(@cooper, "status")

    assert_match(/you have/, response)
  end

  test "status returns if cooper has no late plate today" do
    @cooper.late_plates.create( date: Date.today + 1 )

    response = MessagesService.respond_to_message(@cooper, "status")

    assert_match(/don't have/, response)
  end

  test "it responds with the help message" do
    response = MessagesService.respond_to_message(@cooper, "halp")

    assert_match(/Try something like/, response)
  end

  test "fetch returns the plates tonight" do
    @cooper2 = FactoryGirl.create(:cooper, number: "+12344322344", house: House.foster)
    @cooper2.late_plates.create
    @cooper.late_plates.create
    @cooper.late_plates.create( date: 1.day.from_now )

    response = MessagesService.respond_to_message(@cooper, "fetch")

    assert_match(@cooper.name, response)
    assert_match(@cooper2.name, response)
    assert_match(/are 2 plates/, response)
  end

  test "fetch tells the user there are no plates" do
    response = MessagesService.respond_to_message(@cooper, "fetch")

    assert_match(/No late plates/, response)
    assert_match(Regexp.new(@cooper.house.name), response)
  end

  test "fetch returns the plates tonight for the right house" do
    @cooper.late_plates.create
    @elmwooder = FactoryGirl.create(:elmwooder)
    @elmwooder.late_plates.create

    response = MessagesService.respond_to_message(@elmwooder, "fetch")

    assert_match(@elmwooder.name, response)
    assert_match(/is 1 plate /, response)
  end

  test "it parses unknown messages" do
    assert_difference -> { @cooper.late_plates.count } do
      @response = MessagesService.respond_to_message(@cooper, "tomorrow")
    end

    assert @cooper.has_plate_for_day(Date.today + 1)
    assert_match((Date.today + 1).readable, @response)
  end
end
