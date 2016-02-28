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
    assert_redirected_to_auth_new
  end

  test "#edit" do
    get :edit, id: @organization.id
    assert_response :success
  end

  test "#edit is not authorized when signed out" do
    sign_out

    get :edit, id: @organization.id
    assert_redirected_to_auth_new
  end

  test "#update" do
    patch :update, id: @organization.id, organization: { name: "Henry Corp.", memberships: ["idont@exists.com"] }

    organization = assigns(:organization)
    assert_equal "Henry Corp.", organization.name
    assert_equal users(:gaston), organization.user
    assert_equal 2, organization.memberships.size
    assert_redirected_to edit_account_organization_path(organization)
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch :update, id: @organization.id, organization: { name: "Henry Corp." }
    assert_redirected_to_auth_new
  end

  test "#new" do
    get :new
    assert_response :success
  end

  test "#new is not authorized when signed out" do
    sign_out

    get :new
    assert_redirected_to_auth_new
  end

  test "#create" do
    post :create, organization: { name: "Henry Corp.", memberships: ["idont@exists.com"] }

    organization = assigns(:organization)
    assert_equal "Henry Corp.", organization.name
    assert_equal users(:gaston), organization.user
    assert_equal 2, organization.memberships.size
    assert_redirected_to edit_account_organization_path(organization)
  end

  test "#create is not authorized when signed out" do
    sign_out

    post :create, organization: { name: "Henry Corp." }
    assert_redirected_to_auth_new
  end

  test "#leave" do
    assert_difference("Membership.count", -1) do
      delete :leave, id: @organization.id
    end

    assert_redirected_to account_organizations_path
  end

  test "#leave destroy the organization when there is not other member" do
    @organization.leave(users(:henry))

    assert_difference(["Membership.count", "Organization.count"], -1) do
      delete :leave, id: @organization.id
    end

    assert_redirected_to account_organizations_path
  end

  test "#leave is not authorized when signed out" do
    sign_out

    delete :leave, id: @organization.id
    assert_redirected_to_auth_new
  end
end
