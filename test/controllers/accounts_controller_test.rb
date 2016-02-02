require "test_helper"

class AccountsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:henry)
  end

  test "#edit" do
    get :edit
    assert_response :success
  end

  test "#update" do
    patch :update, user: { name: "Henry II" }
    assert_response :success
  end

  test "#edit is not authorized when signed out" do
    sign_out

    get :edit
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch :update, user: { name: "Henry II" }
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end
end
