require 'test_helper'

class CoopersControllerTest < ActionController::TestCase
  test "create creates a cooper with valid information" do
    assert_difference -> { Cooper.count } do
      post :create, { cooper: {
        fname: "Foo",
        lname: "Bar",
        house: ["Foster","Elmwood"].sample,
        number: "+144455566666",
        uid:    "123abc" }
      }
      assert_redirected_to root_path
      assert_not_nil flash[:success]
      assert cookies[:cooper_id]
    end
  end

  test "does not create cooper with invalid information" do
    assert_no_difference -> { Cooper.count } do
      post :create, { cooper: {
        fname: "Foo",
        lname: "Bar",
        house: ["Foster","Elmwood"].sample,
        number: "+14446666",
        uid: "123abc" }
      }
      assert_redirected_to new_cooper_path
      assert_not_nil flash[:error]
      assert_not cookies[:cooper_id]
    end
  end

  test "it adds uid to existing accounts" do
    @cooper = Cooper.create({
      fname: "Foo",
      lname: "Bar",
      house: ["Foster","Elmwood"].sample,
      number: "+12223334545"
    })

    assert_no_difference -> { Cooper.count } do
      post :create, { cooper: {
        fname: "Foo",
        lname: "Bar",
        house: ["Foster","Elmwood"].sample,
        number: "222-333-4545",
        uid: "123abc" }
      }
    end

    assert_equal "123abc", @cooper.reload.uid
    assert_redirected_to root_path
    assert_not_nil flash[:success]
    assert cookies[:cooper_id]
  end
end
