require "test_helper"

class AccountsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:henry)
  end

  test "#show" do
    get :show

    assert_response :success
  end

  test "#show is not authorized when signed out" do
    sign_out

    get :show
    assert_redirected_to_auth_new
  end

  test "#edit" do
    get :edit
    assert_response :success

    Authorization.available_providers.each do |p|
      assert_select "a[href=?]", auth_authorize_path(p)
    end
  end

  test "#update" do
    patch :update, user: { name: "Henry II" }
    assert_response :success
  end

  test "#edit is not authorized when signed out" do
    sign_out

    get :edit
    assert_redirected_to_auth_new
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch :update, user: { name: "Henry II" }
    assert_redirected_to_auth_new
  end
end
