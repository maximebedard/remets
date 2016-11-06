require "test_helper"

class RegistrationsControllerTest < ActionController::TestCase
  test "#new" do
    get :new
    assert_response :ok
  end

  test "#create" do
    assert_difference "User.count" do
      post :create, params: { user: {
        email: "henry@test.com",
        name: "Henry Lemieux",
        password: "pants...",
      } }
    end
    assert_redirected_to account_profile_path
  end

  test "#create signs in the user" do
    post :create, params: { user: {
      email: "henry@test.com",
      name: "Henry Lemieux",
      password: "pants...",
    } }

    assert_redirected_to account_profile_path
    assert_equal User.last.id, session[Remets::AUTH_SESSION_KEY]
  end
end
