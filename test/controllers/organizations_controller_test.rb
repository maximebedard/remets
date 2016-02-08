require "test_helper"

class OrganizationsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:gaston)
    @organization = organizations(:ets)
  end

  test "#index" do
    get :index
    assert_response :success
  end

  test "#index is not authorized when signed out" do
    sign_out

    get :index
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#show" do
    get :show, id: @organization.id
    assert_response :success
  end

  test "#show is not authorized when signed out" do
    sign_out

    get :show, id: @organization.id
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#edit" do
    get :edit, id: @organization.id
    assert_response :success
  end

  test "#edit is not authorized when signed out" do
    sign_out

    get :edit, id: @organization.id
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#update" do
    patch :update, id: @organization.id, organization: { name: "Henry Corp." }
    assert_redirected_to account_organizations_path
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch :update, id: @organization.id, organization: { name: "Henry Corp." }
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#new" do
    get :new
    assert_response :success
  end

  test "#new is not authorized when signed out" do
    sign_out

    get :new
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end

  test "#create" do
    post :create, organization: { name: "Henry Corp." }
    assert_response :success
  end

  test "#create is not authorized when signed out" do
    sign_out

    post :create, organization: { name: "Henry Corp." }
    assert_redirected_to auth_authorize_path(:google, origin: request.url)
  end
end
