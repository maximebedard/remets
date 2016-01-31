require "test_helper"

class RegistrationsControllerTest < ActionController::TestCase
  include Remets::AuthenticationHelper

  test "#new" do
    get :new
    assert_response :ok
  end

  test "#create" do
    assert_difference "User.count" do
      post :create, user: {
        email: "henry@test.com",
        name: "Henry Lemieux",
        password: "pants...",
      }
    end
    assert_redirected_to dashboards_path
  end
end
