require "test_helper"

class AuthenticationsControllerTest < ActionController::TestCase
  include Remets::AuthenticationHelper

  test "#create with an existing user" do
    mock_auth_request_for(:google, user: users(:gaston))
    assert_no_difference "User.count" do
      post :create, provider: :google
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], users(:gaston).id
    assert_redirected_to "/"
  end

  test "#create with a new user" do
    mock_auth_request_for(
      :google,
      user: User.new(
        uid: "754321",
        name: "Roger Lemieux",
        email: "lemieux.roger@gmail.com",
      ),
    )
    assert_difference "User.count" do
      post :create, provider: :google
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], User.last.id
    assert_redirected_to "/"
  end

  test "#failure" do
    get :failure
    assert_redirected_to root_path
    assert_equal "An error occured when authenticating with Google.", flash[:alert]
  end

  test "#destroy" do
    get :destroy
    assert_redirected_to root_path
    assert_nil session[Remets::AUTH_SESSION_KEY]
  end
end
