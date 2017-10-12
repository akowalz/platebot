require 'test_helper'

class FeedbackControllerTest < ActionController::TestCase
  test "should render textbox at new" do
    sign_in create(:cooper)
    get :new
    assert_response :success
    assert_select "textarea"
  end

  test "should submit feedback to create" do
    assert_difference -> { ActionMailer::Base.deliveries.count } do
      post :create, feedback: "bug report"
    end
    assert_redirected_to root_path
    assert_not_nil flash[:success]

    assert_match(ActionMailer::Base.deliveries.last.body, /bug/)
  end
end
