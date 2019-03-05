require 'test_helper'

class LatePlatesControllerTest < ActionController::TestCase
  def setup
    @cooper = create(:cooper)
    @elmwooder = create(:elmwooder)
  end

  def teardown
    @cooper.destroy
    @elmwooder.destroy
  end

  test "adds late plates for coopers" do
    assert_difference -> { LatePlate.count } do
      post :twilio_endpoint, params: { From: @cooper.number, Body: "Today" }
    end

    assert_equal 1, @cooper.late_plates.count
  end

  test "returns a 403 for strangers" do
    post :twilio_endpoint, params: { From: "+5235556666", Body: "Today" }

    assert_response 403
  end

  test "returns 403 for accounts that have not been sms_confirmed" do
    @cooper = create(:cooper, sms_confirmed: false)

    post :twilio_endpoint, params: { From: @cooper.number, Body: "Today" }

    assert_response 403
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

  test "index does not list repeat plates for members who are not current" do
    inactive_cooper = create(:cooper)
    inactive_cooper.update_attributes(current_member: false)
    inactive_cooper.repeat_plates.create(day: Date.today.wday)

    get :index

    assert_response 200
    assert_select ".late-plate", count: 0
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

    assert_redirected_to "/auth/google_oauth2/"
  end

  test "destroy removes a late plate" do
    sign_in(@cooper)
    @cooper.late_plates.create

    assert_difference -> { @cooper.late_plates.count }, -1 do
      delete :destroy, params: { id: @cooper.late_plates.last.id }
    end

    assert flash[:success]
  end

  test "it gets to the help page" do
    get :help

    assert_response :success
  end
end
