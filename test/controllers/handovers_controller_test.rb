require "test_helper"

class HandoversControllerTest < ActionController::TestCase
  include Remets::DocumentFileUploadHelper

  setup do
    @handover = handovers(:log121_lab1)
  end

  test "#index" do
    get :index

    assert assigns(:handovers)
    assert_response :ok
  end

  test "#edit" do
    get :edit, id: @handover.id

    assert assigns(:handover)
    assert_response :ok
  end

  test "#update" do
    file = sanitizable_file_upload
    patch(
      :update,
      id: @handover.id,
      handover: {
        name: "pants",
        documents_attributes: [{ file_ptr: file }],
      },
    )
    assert_redirected_to assigns(:handover)
  end

  test "#new" do
    get :new

    assert assigns(:handover)
    assert_response :ok
  end

  test "#create" do
    file = sanitizable_file_upload
    post(
      :create,
      handover: {
        name: "pants",
        documents_attributes: [
          { file_ptr: file },
        ],
      },
    )
    assert_redirected_to assigns(:handover)
  end
end
