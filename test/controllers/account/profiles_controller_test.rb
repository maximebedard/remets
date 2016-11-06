require "test_helper"

class Account::ProfilesControllerTest < ActionController::TestCase
  setup do
    @user = users(:henry)
    sign_in @user
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
  end

  test "#edit is not authorized when signed out" do
    sign_out

    get :edit
    assert_redirected_to_auth_new
  end

  test "#update" do
    patch :update, params: { user: { name: "Henry Bonmatin", email: "henry.test@henry.com" } }

    @user.reload

    assert_redirected_to edit_account_profile_path
    assert_equal "Henry Bonmatin", @user.name
    assert_equal "henry.test@henry.com", @user.email
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch :update, params: { user: { name: "Henry Bonmatin" } }
    assert_redirected_to_auth_new
  end
end
