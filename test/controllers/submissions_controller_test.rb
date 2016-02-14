require "test_helper"

class SubmissionsControllerTest < ActionController::TestCase
  include Remets::SanitizedDocumentFileUploadHelper

  setup do
    @handover = handovers(:log121_lab1)
    @submission = submissions(:log121_lab1_1)
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
    get :index, handover_uuid: @handover.uuid

    assert assigns(:submissions)
    assert_response :ok
  end

  test "#index for a handover with no submissions" do
    get :index, handover_uuid: handovers(:gti772_final).uuid

    assert assigns(:submissions)
    assert_response :ok
  end

  test "#index is not authorized when signed out" do
    sign_out

    get :index, handover_uuid: @handover.uuid
    assert_redirected_to_auth_new
  end

  test "#show" do
    get :show, id: @submission.id

    assert assigns(:submission)
    assert_response :ok
  end

  test "#show is not authorized when signed out" do
    sign_out

    get :show, id: @submission.id
    assert_redirected_to_auth_new
  end

  test "#create" do
    post :create,
      handover_uuid: @handover.uuid,
      submission: { documents_attributes: [{ file_ptr: sanitizable_file_upload }] }

    assert_redirected_to assigns(:submission)
  end

  test "#create is not authorized when signed out" do
    sign_out

    post :create,
      handover_uuid: @handover.uuid,
      submission: { documents_attributes: [{ file_ptr: sanitizable_file_upload }] }

    assert_redirected_to_auth_new
  end

  test "#new" do
    get :new, handover_uuid: @handover.uuid

    assert assigns(:submission)
    assert_response :ok
  end

  test "#new is not authorized when signed out" do
    sign_out

    get :new, handover_uuid: @handover.uuid
    assert_redirected_to_auth_new
  end
end
