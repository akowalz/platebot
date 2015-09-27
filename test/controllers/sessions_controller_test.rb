require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    @cooper_params = {
      fname: "Foo",
      lname: "Bar",
      uid: OmniAuth.config.mock_auth[:google_oauth2][:uid],
      number: "+19998887777",
      house: House.first,
    }
  end

  def teardown
    @cooper.destroy
  end

  test "it signs in users it recognizes" do
    @cooper = Cooper.create(@cooper_params)

    post :create
    assert_equal cookies[:cooper_id], @cooper.id
    assert_not_nil flash[:success]
    assert_redirected_to root_path
  end

  test "it renders new for users it doesn't recognize" do
    @cooper_params[:uid] = nil
    @cooper = Cooper.create(@cooper_params)

    post :create
    assert_nil cookies[:cooper_id]
    assert_template 'coopers/new'
  end

  test "it signs out logged in users" do
    @cooper = Cooper.create(@cooper_params)
    delete :destroy
    assert_nil cookies[:cooper_id]
  end
end
