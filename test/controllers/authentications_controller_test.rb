require "test_helper"

class AuthenticationsControllerTest < ActionController::TestCase
  include Remets::AuthenticationHelper

  test "#callback with an existing user using oauth" do
    mock_auth_request_for(:google, user: users(:gaston))
    assert_no_difference("User.count", "Authorization.count") do
      post :callback, provider: :google
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], users(:gaston).id
    assert_redirected_to root_path
  end

  test "#callback with the login page as origin redirects to the root page" do
    mock_auth_request_for(:google, user: users(:gaston))
    request.env["omniauth.origin"] = auth_new_url
    post :callback, provider: :google
    assert_equal session[Remets::AUTH_SESSION_KEY], users(:gaston).id
    assert_redirected_to root_path
  end

  test "#callback with a new user using oauth" do
    mock_auth_request_for(
      :google,
      user: User.new(
        name: "Roger Lemieux",
        email: "lemieux.roger@gmail.com",
      ),
      authorization: Authorization.new(
        provider: "google",
        uid: "987654321",
        secret: "90980784187ec4f28447539e10ea80c3",
        token: "3f1a00866f78690b758bb2ad28bb73fa",
      ),
    )
    assert_difference(["User.count", "Authorization.count"]) do
      post :callback, provider: :google
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], User.last.id
    assert_redirected_to root_path
  end

  test "#callback when signed in add an authorization" do
    sign_in users(:henry)
    mock_auth_request_for(
      :google,
      user: users(:henry),
      authorization: Authorization.new(
        provider: "google",
        uid: "987654321",
        secret: "90980784187ec4f28447539e10ea80c3",
        token: "3f1a00866f78690b758bb2ad28bb73fa",
      ),
    )
    assert_no_difference("User.count") do
      assert_difference("Authorization.count") do
        post :callback, provider: :google
      end
    end
    assert_equal session[Remets::AUTH_SESSION_KEY], users(:henry).id
    assert_redirected_to root_path
  end

  test "#new" do
    get :new
    assert_response :success
  end

  test "#new when signed in redirects to the root page" do
    sign_in users(:gaston)

    get :new
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
