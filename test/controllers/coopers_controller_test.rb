require 'test_helper'

class CoopersControllerTest < ActionController::TestCase
  def setup
    @cooper = FactoryGirl.create(:cooper)
  end

  def teardown
    @cooper.destroy
  end

  test "#create creates a cooper with valid information" do
    assert_difference -> { Cooper.count } do
      post :create, { cooper: {
        fname: "foo",
        lname: "bar",
        house_id: 0,
        number: "+12225556666",
        uid: "123abc456" }
      }

      assert_redirected_to new_cooper_sms_confirmation_path(Cooper.find_by(uid: "123abc456"))
      assert cookies[:cooper_id]
    end
  end

  test "does not create cooper with invalid information" do
    assert_no_difference -> { Cooper.count } do
      post :create, { cooper: {
        fname: "Foo",
        lname: "Bar",
        house_id: 0,
        number: "+14446666",
        uid: "123abc" }
      }
      assert_redirected_to new_cooper_path
      assert_not_nil flash[:error]
      assert_not cookies[:cooper_id]
    end
  end

  test "users can view form to edit their information" do
    get :edit, { id: @cooper.id.to_s }
    assert_response :success
    assert_select "form"
  end

  test "submiting form with valid information updates cooper" do
    new_number = "111-222-3333"
    new_first = "Bill"
    new_last = "Ready"
    patch :update, { id: @cooper.id.to_s,
                     cooper: {
      fname: new_first,
      lname: new_last,
      number: new_number,
      house_id: 0,
    } }

    assert_equal "+11112223333", @cooper.reload.number
    assert_equal new_first, @cooper.fname
    assert_equal new_last, @cooper.lname
    assert_redirected_to "/"
    assert_not_nil flash[:success]
  end


  test "submiting form with invalid information rerenders form" do
    invalid_number = "111-22-3333"
    patch :update, { id: @cooper.id.to_s,
                     cooper: {
      fname: @cooper.fname,
      lname: @cooper.lname,
      number: invalid_number,
      house_id: 0,
    } }

    assert_not_equal invalid_number, @cooper.number
    assert_template "edit"
    assert_not_nil flash.now[:error]
  end
end
