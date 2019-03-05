require 'test_helper'

class SmsConfirmationsControllerTest < ActionController::TestCase
  def setup
    @cooper = create(:cooper, sms_confirmed: false)
  end

  def teardown
    @cooper.destroy
  end

  test "#create sms confirmation with valid confirmation code" do
    post :create, params: { 
      cooper_id: @cooper.id.to_s,
      cooper: { sms_confirmation_code: @cooper.sms_confirmation_code }
    }

    assert @cooper.reload.sms_confirmed?
    assert_not_nil flash[:success]
    assert_redirected_to root_path
  end

  test "#create confirmation with invalid confirmation code" do
    post :create, params: {
      cooper_id: @cooper.id.to_s,
      cooper: { sms_confirmation_code: "invalid" }
    }

    assert_not @cooper.reload.sms_confirmed?
    assert_not_nil flash[:error]
    assert_redirected_to new_cooper_sms_confirmation_path(@cooper)
  end

  test "#new renders" do
    get :new, params: { cooper_id: @cooper.id.to_s }

    assert_response :success
  end
end
