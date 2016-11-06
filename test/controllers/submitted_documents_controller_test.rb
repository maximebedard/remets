require "test_helper"

class SubmittedDocumentsControllerTest < ActionController::TestCase
  setup do
    @submitted_document = submitted_documents(:platypus)
    @compared_submitted_document = submitted_documents(:fraudulent_platypus)
    sign_in(users(:henry))
  end

  test "#show" do
    get :show, params: { id: @submitted_document.id }

    assert assigns(:submitted_document)
    assert_response :ok
  end

  test "#show is not authorized when signed out" do
    sign_out

    get :show, params: { id: @submitted_document.id }
    assert_redirected_to_auth_new
  end

  test "#show is not authorized when you are not the owner nor the creator of the evaluation" do
    sign_in(users(:marcel))

    get :show, params: { id: @submitted_document.id }
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:danger]
  end

  test "#diff" do
    get :diff, params: { id: @submitted_document.id, compared_id: @compared_submitted_document.id }

    assert assigns(:reference)
    assert assigns(:compared)

    assert_response :ok
  end

  test "#diff is not authorized when signed out" do
    sign_out

    get :diff, params: { id: @submitted_document.id, compared_id: @compared_submitted_document.id }
    assert_redirected_to_auth_new
  end
end
