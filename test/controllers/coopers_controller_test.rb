require 'test_helper'

class CoopersControllerTest < ActionController::TestCase
  test "can get to new" do
    get :new
    assert_response :success
  end

  test "create creates a cooper with valid information" do
    assert_difference -> { Cooper.count } do
      post :create, { cooper: {
        fname: "Foo",
        lname: "Bar",
        house: ["Foster","Elmwood"].sample,
        number: "+144455566666" }
      }
      assert_redirected_to root_path
      assert_not_nil flash[:success]
    end
  end

  test "does not create cooper with invalid information" do
    assert_no_difference -> { Cooper.count } do
      post :create, { cooper: {
        fname: "Foo",
        lname: "Bar",
        house: ["Foster","Elmwood"].sample,
        number: "+14446666" }
      }
      assert_redirected_to new_cooper_path
      assert_not_nil flash[:error]
    end
  end

  test "shows coopers upcoming late plates" do
    skip("Not doing show right now")
    cooper = Cooper.create( { fname: "Foo",
                              lname: "bar",
                              house: "foster",
                              number: "+12223334444" } )
    5.times do
      cooper.late_plates.create( { dt: DateTime.now + rand(3) } )
    end
    4.times do
      cooper.late_plates.create( { dt: DateTime.now - rand(3) } )
    end

    assert_select ".late-plate", count: 5
  end
end
