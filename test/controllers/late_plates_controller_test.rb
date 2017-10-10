require 'test_helper'

class LatePlatesControllerTest < ActionController::TestCase
  def setup
    @cooper = FactoryGirl.create(:cooper)
    @elmwooder = FactoryGirl.create(:elmwooder)
  end

  def teardown
    @cooper.destroy
    @elmwooder.destroy
  end

  test "adds late plates for coopers" do
    assert_difference -> { LatePlate.count } do
      post :twilio_endpoint, { From: @cooper.number, Body: "Today" }
    end
    assert_equal 1, @cooper.late_plates.count
  end

  test "returns a 403 for strangers" do
    post :twilio_endpoint, { From: "+5235556666", Body: "Today" }

    assert_response 403
  end

  test "returns 403 for unactivated accounts" do
    @cooper = FactoryGirl.create(:cooper, active: false)

    post :twilio_endpoint, { From: @cooper.number, Body: "Today" }

    assert_response 403
  end

  test "adds late plates for tomorrow" do
    post :twilio_endpoint, From: @cooper.number, Body: "Tomorrow"

    assert @cooper.late_plates.last.date > Date.today,
      "Time was #{@cooper.late_plates.last.date}"
  end

  test "adds late plates with command" do
    assert_difference -> { LatePlate.count } do
      post :twilio_endpoint, { From: @cooper.number, Body: "late plate" }
    end
    assert LatePlate.last.date <= Date.today
  end

  test "does not add late plate twice" do
    @cooper.late_plates.create( date: Date.today )

    assert_no_difference -> { LatePlate.count } do
      post :twilio_endpoint, { From: @cooper.number, Body: "today" }
    end
    assert_select "Message", /already/
  end

  test "does not break when given bad date" do
    assert_no_difference -> { @cooper.late_plates.count } do
      post :twilio_endpoint, { From: @cooper.number, Body: "adlghalsdhg" }
    end
    assert_select "Message", /sorry/i
  end

  test "removes coopers most recent late plate when given command" do
    @cooper.late_plates.create( date: Date.today )
    assert_difference -> { @cooper.late_plates.count }, -1 do
      post :twilio_endpoint, { From: @cooper.number, Body: "Undo!" }
    end
    assert_select "Message", /removed/i
  end

  test "let's cooper know there was no plate to destroy" do
    assert_no_difference -> { @cooper.late_plates.count }, -1 do
      post :twilio_endpoint, { From: @cooper.number, Body: "remove." }
    end
    assert_select "Message", /don't/
  end

  test "status returns if the cooper has a late plate today" do
    @cooper.late_plates.create( date: Date.today )
    @cooper.late_plates.create( date: Date.today.tomorrow )
    assert_no_difference -> { @cooper.late_plates.count } do
      post :twilio_endpoint, { From: @cooper.number, Body: "  Status" }
    end
    assert_select "Message", /a late plate/
  end

  test "status returns if cooper has no late plate today" do
    @cooper.late_plates.create( date: Date.today.tomorrow )
    assert_no_difference -> { @cooper.late_plates.count } do
      post :twilio_endpoint, { From: @cooper.number, Body: "Status" }
    end
    assert_select "Message", /don't/
  end

  test "fetch returns the plates tonight" do
    @cooper.late_plates.create
    @cooper.late_plates.create( date: 1.day.from_now )
    post :twilio_endpoint, { From: @cooper.number, Body: "get all" }
    assert_select "Message", /1/
    assert_select "Message", /#{@cooper.name}/
  end

  test "fetch returns the plates tonight for the right house" do
    @cooper.late_plates.create
    @elmwooder.late_plates.create
    post :twilio_endpoint, { From: @elmwooder.number, Body: "get all" }
    assert_select "Message", /1/
    assert_select "Message", /#{@elmwooder.name}/
  end

  test "help returns some help options" do
    assert_no_difference -> { @cooper.late_plates.count } do
      post :twilio_endpoint, { From: @cooper.number, Body: "howto  " }
    end
    assert_select "Message", /status/
  end

  test "index lists today's late plates for both houses without a current user" do
    @cooper.late_plates.create( date: Date.today )
    @elmwooder.late_plates.create( date: Date.today )

    get :index
    assert_response 200
    assert_select ".late-plate", count: 2
  end

  test "index does not list tomorrow's late plates" do
    @cooper.late_plates.create( date: Date.today )
    @cooper.late_plates.create( date: Date.tomorrow )
    @cooper.late_plates.create( date: Date.yesterday )

    get :index
    assert_response 200
    assert_select ".late-plate", count: 1
  end

  test "if user is signed in, it shows the plates from their house" do
    sign_in @elmwooder
    @elmwooder.late_plates.create
    @cooper.late_plates.create

    get :index
    assert_response 200
    assert_select ".late-plate", count: 1
  end

  test "index lists current single plates and repeat plates for a day" do
    @cooper.repeat_plates.create( day: Date.today.wday )

    get :index
    assert_response 200
    assert_select ".late-plate", count: 1
  end

  test "create adds a late plate for the current user" do
    sign_in(@cooper)

    assert_difference -> { @cooper.late_plates.for_today.count } do
      post :create
    end
    assert flash[:success]
  end

  test "create does not add a late plate for the same day" do
    sign_in(@cooper)
    @cooper.late_plates.create

    assert_no_difference -> { @cooper.late_plates.for_today.count } do
      post :create
    end
    assert_not flash[:success]
    assert flash[:error]
  end

  test "create does not add a late plate unless signed in" do
    assert_no_difference -> { @cooper.late_plates.count } do
      post :create
    end
    assert_redirected_to "/auth/google_oauth2"
  end

  test "destroy removes a late plate" do
    sign_in(@cooper)
    @cooper.late_plates.create

    assert_difference -> { @cooper.late_plates.count }, -1 do
      delete :destroy, id: @cooper.late_plates.last.id
    end
    assert flash[:success]
  end

  test "it gets to the help page" do
    get :help
    assert_response :success
  end
end
