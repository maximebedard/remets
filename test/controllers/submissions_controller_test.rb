require "test_helper"

class SubmissionsControllerTest < ActionController::TestCase
  setup do
    @evaluation = evaluations(:log121_lab1)
    @submission = submissions(:log121_lab1_1)
    @compared_submission = submissions(:log121_lab1_2)
    sign_in users(:henry)
  end

  test "#all" do
    get :all

    assert assigns(:submissions)
    assert_response :ok
  end

  test "#all is not authorized when signed out" do
    sign_out

    get :all
    assert_redirected_to_auth_new
  end

  test "#index" do
    get :index, params: { evaluation_uuid: @evaluation.uuid }

    assert assigns(:submissions)
    assert_response :ok
  end

  test "#index for a evaluation with no submissions" do
    get :index, params: { evaluation_uuid: evaluations(:gti772_final).uuid }

    assert assigns(:submissions)
    assert_response :ok
  end

  test "#index is not authorized when signed out" do
    sign_out

    get :index, params: { evaluation_uuid: @evaluation.uuid }
    assert_redirected_to_auth_new
  end

  test "#show" do
    get :show, params: { id: @submission.id }

    assert assigns(:submission)
    assert_response :ok
  end

  test "#show is not authorized when signed out" do
    sign_out

    get :show, params: { id: @submission.id }
    assert_redirected_to_auth_new
  end

  test "#create" do
    post :create, params: { evaluation_uuid: @evaluation.uuid, submission: {
      submitted_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
    } }

    assert_redirected_to assigns(:submission)
  end

  test "#create is not authorized when signed out" do
    sign_out

    post :create, params: { evaluation_uuid: @evaluation.uuid, submission: {
      submitted_documents_attributes: [{ file_ptr: submitted_documents(:bragging).file_ptr }],
    } }

    assert_redirected_to_auth_new
  end

  test "#new" do
    get :new, params: { evaluation_uuid: @evaluation.uuid }

    assert assigns(:submission)
    assert_response :ok
  end

  test "#new is not authorized when signed out" do
    sign_out

    get :new, params: { evaluation_uuid: @evaluation.uuid }
    assert_redirected_to_auth_new
  end

  test "#diff" do
    get :diff, params: { id: @submission.id, compared_id: @compared_submission.id }

    assert assigns(:reference)
    assert assigns(:compared)

    assert_response :ok
  end

  test "#diff is not authorized when signed out" do
    sign_out

    get :diff, params: { id: @submission.id, compared_id: @compared_submission.id }
    assert_redirected_to_auth_new
  end
end
