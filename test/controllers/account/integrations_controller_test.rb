require "test_helper"

class Account::IntegrationsControllerTest < ActionController::TestCase
  setup do
    @user = users(:gaston)
    sign_in @user
  end

  test "#index" do
    get :index
    assert_response :success
  end

  test "#index is not authorized when signed out" do
    sign_out

    get :index
    assert_redirected_to_auth_new
  end

  test "#new" do
    get :new
    assert_response :success

    Authorization.available_providers.each do |provider|
      assert_select "a[href=?]", auth_authorize_path(provider)
    end
  end

  test "#new is not authorized when signed out" do
    sign_out

    get :new
    assert_redirected_to_auth_new
  end
end
