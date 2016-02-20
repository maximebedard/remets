require "test_helper"

class HandoversControllerTest < ActionController::TestCase
  include Remets::SanitizedDocumentFileUploadHelper

  setup do
    @handover = handovers(:log121_lab1)
    sign_in users(:gaston)
  end

  test "#index" do
    get :index

    assert assigns(:handovers)
    assert_response :ok
  end

  test "#index is not authorized when signed out" do
    sign_out

    get :index
    assert_redirected_to_auth_new
  end

  test "#show" do
    get :show, uuid: @handover.uuid

    assert assigns(:handover)
    assert_response :ok
  end

  test "#show is not authorized when signed out" do
    sign_out

    get :show, uuid: @handover.uuid
    assert_redirected_to_auth_new
  end

  test "#edit" do
    get :edit, uuid: @handover.uuid

    assert assigns(:handover)
    assert_response :ok
  end

  test "#edit is not authorized when signed out" do
    sign_out

    get :edit, uuid: @handover.uuid
    assert_redirected_to_auth_new
  end

  test "#update" do
    patch(
      :update,
      uuid: @handover.uuid,
      handover: {
        title: "pants",
        reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        documents_attributes: [{ file_ptr: sanitizable_file_upload }],
      },
    )
    assert_redirected_to handover_path(uuid: assigns(:handover).uuid)
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch(
      :update,
      uuid: @handover.uuid,
      handover: {
        title: "pants",
        reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        documents_attributes: [{ file_ptr: sanitizable_file_upload }],
      },
    )
    assert_redirected_to_auth_new
  end

  test "#new" do
    get :new

    assert assigns(:handover)
    assert_response :ok
  end

  test "#new is not authorized when signed out" do
    sign_out

    get :new
    assert_redirected_to_auth_new
  end

  test "#create" do
    post(
      :create,
      handover: {
        title: "pants",
        reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        documents_attributes: [{ file_ptr: sanitizable_file_upload }],
      },
    )
    assert_redirected_to handover_path(uuid: assigns(:handover).uuid)
  end

  test "#create is not authorized when signed out" do
    sign_out

    post(
      :create,
      handover: {
        title: "pants",
        reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        due_date: 5.days.from_now,
      },
    )
    assert_redirected_to_auth_new
  end
end
