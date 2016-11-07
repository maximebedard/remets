require "test_helper"

class AuthenticationsControllerTest < ActionController::TestCase
  test "#callback with an existing user using oauth" do
    mock_auth_request_for(:google, user: users(:gaston))

    assert_no_difference("User.count", "Authorization.count") do
      post :callback, params: { provider: :google }
    end

    assert_equal users(:gaston).id, session[Remets::AUTH_SESSION_KEY]
    assert_redirected_to account_profile_path
  end

  test "#callback with the omniauth origin redirects to the origin" do
    mock_auth_request_for(:google, user: users(:gaston))
    request.env["omniauth.origin"] = auth_new_url

    post :callback, params: { provider: :google }

    assert_not_nil session[Remets::AUTH_SESSION_KEY]
    assert_redirected_to account_profile_path
  end

  test "#callback with the origin redirects to the origin" do
    mock_auth_request_for(:google, user: users(:gaston))
    session[Remets::ORIGIN_KEY] = "https://google.ca"

    post :callback, params: { provider: :google }

    assert_not_nil session[Remets::AUTH_SESSION_KEY]
    assert_redirected_to "https://google.ca"
    assert_nil session[Remets::ORIGIN_KEY]
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
        token: "3f1a00866f78690b758bb2ad28bb73fa",
        refresh_token: "56e1cd5ef068ef9e58b6be39af878802",
        expires_at: Time.zone.now + 3600.seconds,
      ),
    )

    assert_difference(["User.count", "Authorization.count"]) do
      post :callback, params: { provider: :google }
    end

    assert_equal User.last.id, session[Remets::AUTH_SESSION_KEY]
    assert_redirected_to account_profile_path
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
        refresh_token: "50d0335e538546a23c4fc80e31a604aa",
        expires_at: Time.zone.now + 3600.seconds,
      ),
    )

    assert_no_difference("User.count") do
      assert_difference("Authorization.count") do
        post :callback, params: { provider: :google }
      end
    end

    assert_equal users(:henry).id, session[Remets::AUTH_SESSION_KEY]
    assert_redirected_to account_profile_path
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
    authentication_params = { email: "rinfrette.gaston@gmail.com", password: "password" }

    post :create, params: { authentication: authentication_params }

    assert_equal users(:gaston).id, session[Remets::AUTH_SESSION_KEY]
    assert_redirected_to account_profile_path
  end

  test "#create with the origin redirects to the origin" do
    session[Remets::ORIGIN_KEY] = "https://google.ca"
    authentication_params = { email: "rinfrette.gaston@gmail.com", password: "password" }

    post :create, params: { authentication: authentication_params }

    assert_not_nil session[Remets::AUTH_SESSION_KEY]
    assert_redirected_to "https://google.ca"
    assert_nil session[Remets::ORIGIN_KEY]
  end

  test "#create with an existing user but invalid password" do
    authentication_params = { email: "rinfrette.gaston@gmail.com", password: "potato" }

    post :create, params: { authentication: authentication_params }

    assert_nil session[Remets::AUTH_SESSION_KEY]
    assert_equal "Email/Password combination does not match", flash[:danger]
    assert_response :ok
  end

  test "#create with a non existing user" do
    authentication_params = { email: "asdasdasd@gmail.com", password: "potato" }

    post :create, params: { authentication: authentication_params  }

    assert_nil session[Remets::AUTH_SESSION_KEY]
    assert_equal "Email/Password combination does not match", flash[:danger]
    assert_response :ok
  end

  test "#create will remember the user" do
    user = users(:gaston)
    authentication_params = { email: user.email, password: "password", remember_me: true }

    post :create, params: { authentication: authentication_params }

    user.reload
    assert_equal user.id, session[Remets::AUTH_SESSION_KEY]
    assert_equal user.id, cookies.permanent.signed[Remets::AUTH_REMEMBER_KEY]
    assert user.remembered?(cookies.permanent[Remets::AUTH_REMEMBER_TOKEN])
    assert_redirected_to account_profile_path
  end

  test "#failure" do
    get :failure

    assert_redirected_to root_path
    assert_equal "An error occured when authenticating with Google.", flash[:danger]
  end

  test "#destroy" do
    get :destroy

    assert_redirected_to root_path
    assert_nil session[Remets::AUTH_SESSION_KEY]
  end
end
