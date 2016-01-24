require "test_helper"

class SubmissionsControllerTest < ActionController::TestCase
  include Remets::SanitizedDocumentFileUploadHelper

  setup do
    @submission = submissions(:log121_lab1)
  end

  test "#index" do
    get :index

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

    post :create, submission: { documents_attributes: [{ file_ptr: file }] }

    assert_redirected_to assigns(:submission)
  end

  test "#new" do
    get :new

    assert assigns(:submission)
    assert_response :ok
  end
end
