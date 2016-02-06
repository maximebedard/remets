require "test_helper"

class SubmissionsControllerTest < ActionController::TestCase
  include Remets::SanitizedDocumentFileUploadHelper

  setup do
    @handover = handovers(:log121_lab1)
    @submission = submissions(:log121_lab1_1)
  end

  test "#all" do
    get :all

    assert assigns(:submissions)
    assert_response :ok
  end

  test "#index" do
    get :index, handover_uuid: @handover.uuid

    assert assigns(:submissions)
    assert_response :ok
  end

  test "#show" do
    get :show, id: @submission.id

    assert assigns(:submission)
    assert_response :ok
  end

  test "#create" do
    file = sanitizable_file_upload

    post :create,
      handover_uuid: @handover.uuid,
      submission: { documents_attributes: [{ file_ptr: file }] }

    assert_redirected_to assigns(:submission)
  end

  test "#new" do
    get :new, handover_uuid: @handover.uuid

    assert assigns(:submission)
    assert_response :ok
  end
end
