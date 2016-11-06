require "test_helper"

class Account::SecuritiesControllerTest < ActionController::TestCase
  setup do
    @user = users(:henry)
    sign_in @user
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
    patch :update, params: { user: { password: "henry12345", password_confirmation: "henry12345" } }

    @user.reload

    assert_redirected_to edit_account_security_path
    assert @user.authenticate("henry12345")
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch :update, params: { user: { password: "henry12345", password_confirmation: "henry12345" } }
    assert_redirected_to_auth_new
  end
end
