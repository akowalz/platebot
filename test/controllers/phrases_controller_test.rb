require 'test_helper'

class PhrasesControllerTest < ActionController::TestCase
  def setup
    @cooper = create(:cooper)
    @elmwooder = create(:elmwooder)
  end

  test "index shows a cooper's phrases" do
    sign_in @cooper
    @cooper.phrases.create( text: "my cool phrase" )

    get :index, params: { cooper_id: @cooper }
    assert_response :success
    assert_select "li.phrase", count: 1
    assert_match "my cool phrase", response.body
  end

  test "only shows a signed in users own phrases" do
    get :index, params: { cooper_id: @cooper }
    assert_redirected_to root_path
    assert_not_nil flash[:warning]
  end

  test "only shows a user their own phrases" do
    sign_in @elmwooder
    get :index, params: { cooper_id: @cooper }
    assert_redirected_to root_path
    assert_not_nil flash[:warning]
  end

  test "create adds a phrase" do
    sign_in @cooper
    assert_difference -> { @cooper.phrases.count } do
      post :create, params: { cooper_id: @cooper.id, phrase: { text: "cool text" } }
    end

    assert_equal @cooper.phrases.last.text, "cool text"
  end

  test "create won't add an invalid phrase" do
    sign_in @cooper
    assert_no_difference -> { @cooper.phrases.count } do
      post :create, params: { cooper_id: @cooper.id, phrase: { text: "a" * 61 } }
    end

    assert_match "too long", flash[:error].first
  end

  test "create won't add more phrases than allowed" do
    sign_in @cooper
    3.times { @cooper.phrases.create( text: "gdlkj" ) }

    assert_no_difference -> { @cooper.phrases.count } do
      post :create, params: { cooper_id: @cooper.id, phrase: { text: "not allowed" } }
    end

    assert_match "only", flash[:error].first
  end

  test "destroy deletes a phrase" do
    sign_in @cooper
    @cooper.phrases.create( text: "asdjgliasjdg" )

    assert_difference -> { @cooper.phrases.all.count }, -1 do
      delete :destroy, params: { id: @cooper.phrases.last.id, cooper_id: @cooper.id }
    end

    assert_not_nil flash[:success]
  end

  test "only shows form if user has less then the max number of phrases" do
    sign_in @cooper
    3.times { @cooper.phrases.create( text: "gdlkj" ) }

    get :index, params: { cooper_id: @cooper }

    assert_select "form", false
  end
end
