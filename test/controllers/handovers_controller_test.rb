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
    travel_to(Time.zone.now) do
      patch(
        :update,
        uuid: @handover.uuid,
        handover: {
          title: "pants",
          description: "pants pants pants",
          due_date: 5.days.from_now,
          organization_id: organizations(:ets).id,
          reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
          boilerplate_documents_attriubtes: [{ file_ptr: sanitizable_file_upload }],
        },
      )
      handover = assigns(:handover)
      assert_equal "pants", handover.title
      assert_equal "pants pants pants", handover.description
      assert_equal 5.days.from_now, handover.due_date
      assert_equal "École de technologie supérieure", handover.organization.name
      assert_equal 1, handover.reference_documents.size
      assert_equal 4, handover.boilerplate_documents.size
      assert_redirected_to handover_path(uuid: handover.uuid)
    end
  end

  test "#update is not authorized when signed out" do
    sign_out

    patch(
      :update,
      uuid: @handover.uuid,
      handover: {
        title: "pants",
        description: "pants pants pants",
        due_date: 5.days.from_now,
        organization_id: organizations(:ets).id,
        reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        boilerplate_documents_attriubtes: [{ file_ptr: sanitizable_file_upload }],
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
    travel_to(Time.zone.now) do
      post(
        :create,
        handover: {
          title: "pants",
          description: "pants pants pants",
          due_date: 5.days.from_now,
          organization_id: organizations(:ets).id,
          subscriptions: ["idont@exists.com"],
          reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
          boilerplate_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        },
      )

      handover = assigns(:handover)
      assert_equal "pants", handover.title
      assert_equal "pants pants pants", handover.description
      assert_equal 5.days.from_now, handover.due_date
      assert_equal "École de technologie supérieure", handover.organization.name
      assert_equal 1, handover.reference_documents.size
      assert_equal 1, handover.boilerplate_documents.size
      assert_equal 1, handover.subscriptions.size
      assert_equal "idont@exists.com", handover.users.first.email
      assert_redirected_to handover_path(uuid: handover.uuid)
    end
  end

  test "#create invite new subscribers" do
    assert_difference("User.count") do
      post(
        :create,
        handover: {
          title: "pants",
          description: "pants pants pants",
          due_date: 5.days.from_now,
          organization_id: organizations(:ets).id,
          subscriptions: ["idont@exists.com"],
          reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
          boilerplate_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        },
      )
      assert_redirected_to handover_path(uuid: assigns(:handover).uuid)
    end
  end

  test "#create does not invite new subscribers when invalid" do
    assert_no_difference("User.count") do
      post(
        :create,
        handover: {
          subscriptions: ["idont@exists.com"],
        },
      )
      assert_template "new"
    end
  end

  test "#create is not authorized when signed out" do
    sign_out

    post(
      :create,
      handover: {
        title: "pants",
        description: "pants pants pants",
        due_date: 5.days.from_now,
        reference_documents_attributes: [{ file_ptr: sanitizable_file_upload }],
        documents_attributes: [{ file_ptr: sanitizable_file_upload }],
      },
    )
    assert_redirected_to_auth_new
  end
end
