require "test_helper"

class AuthenticationsControllerTest < ActionController::TestCase
  include Remets::AuthenticationHelper

  test "#callback with an existing user using oauth" do
    mock_auth_request_for(:google, user: users(:gaston))
    assert_no_difference "User.count" do
      post :callback, provider: :google
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], users(:gaston).id
    assert_redirected_to root_path
  end

  test "#callback with a new user using oauth" do
    mock_auth_request_for(
      :google,
      user: User.new(
        uid: "754321",
        name: "Roger Lemieux",
        email: "lemieux.roger@gmail.com",
      ),
    )
    assert_difference "User.count" do
      post :callback, provider: :google
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], User.last.id
    assert_redirected_to root_path
  end

  test "#create with an existing user" do
    post :create, authentication: { email: "rinfrette.gaston@gmail.com", password: "password" }
    assert_equal session[Remets::AUTH_SESSION_KEY], users(:gaston).id
    assert_redirected_to dashboards_path
  end

  test "#create with an existing user but invalid password" do
    post :create, authentication: { email: "rinfrette.gaston@gmail.com", password: "potato" }
    assert_nil session[Remets::AUTH_SESSION_KEY]
    assert_equal "Email/Password combination does not match", flash[:alert]
    assert_response :ok
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
